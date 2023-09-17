import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);
  String imageUrl = "";
  User? user = FirebaseAuth.instance.currentUser;

  //references of our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference listsCollection =
      FirebaseFirestore.instance.collection("lists");

  //when registered, it saves the user data
  Future savingUserData(
    String username,
    String email,
    String profilePic,
  ) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "email": email,
      "favourites": [],
      "createdLists": [],
      "watchLater": [],
      "followedLists": [],
      "profilePic": profilePic,
      "userId": uid
    });
  }

  //uploading a profile picture to the user
  Future<String> uploadProfilePhotoAndGetUrl() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('profilePhotos');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      return imageUrl;
    } else {
      return "";
    }
  }

  //deleting images from firebase
  Future deleteImageFromFirebase(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  //getting the username
  Future<String> getUsername() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      String usernameValue = doc.get('username');
      return usernameValue;
    } else {
      return '';
    }
  }

  //getting the profile picture
  Future<String> getProfilePic() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      String profilePicvalue = doc.get('profilePic');
      return profilePicvalue;
    } else {
      return '';
    }
  }

  //add it to the favorites
  Future<void> addOrDeleteFavorites(
    String name,
    int movieId,
    String description,
    String bannerUrl,
    String posterUrl,
    String vote,
    String launchOn,
    bool isItMovie,
  ) async {
    DocumentReference docRef = userCollection.doc(uid);
    final flag = await checkIfAlreadyLiked(movieId);
    if (flag == false) {
      await docRef.update({
        "favorites": FieldValue.arrayUnion([
          {
            'name': name,
            'id': movieId,
            'description': description,
            'bannerUrl': bannerUrl,
            'posterUrl': posterUrl,
            'vote': vote,
            'launchOn': launchOn,
            'isItMovie': isItMovie,
          }
        ])
      });
    } else {
      await removeFromFavorites(movieId);
    }
  }

  // the checking the movie is already exists in db
  Future<bool> checkIfAlreadyLiked(int movieId) async {
    try {
      DocumentReference docRef = userCollection.doc(uid);
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData['favorites'] != null) {
          List<dynamic> favorites = userData['favorites'];

          bool movieExists = favorites.any((movie) => movie['id'] == movieId);

          return movieExists;
        }
      }
      return false;
    } catch (e) {
      log("Error checking if movie exists: $e");
      return false;
    }
  }

  //handling the process of removing a member of favorites
  Future removeFromFavorites(int id) async {
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    try {
      if (snapshot.exists) {
        if (snapshot['favorites'] != null) {
          List<dynamic> favorites = snapshot['favorites'];
          List<dynamic> updatedFavorites = [];
          for (var favorite in favorites) {
            if (favorite['id'] != id) {
              updatedFavorites.add(favorite);
            }
          }
          await docRef.update({'favorites': updatedFavorites});
        }
      }
    } catch (e) {
      log('error deleting favorite');
    }
  }

  //getting the data of favorites
  Future<List> getFavorites() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      List favorites = doc.get('favorites');
      return favorites;
    } else {
      return [];
    }
  }

  // add it to the watch later
  Future<void> addOrDeleteWatchListItems(
    String name,
    int movieId,
    String description,
    String bannerUrl,
    String posterUrl,
    String vote,
    String launchOn,
    bool isItMovie,
  ) async {
    DocumentReference docRef = userCollection.doc(uid);
    final flag = await checkIfAlreadyOnWatchList(movieId);
    if (flag == false) {
      await docRef.update({
        "watchLater": FieldValue.arrayUnion([
          {
            'name': name,
            'id': movieId,
            'description': description,
            'bannerUrl': bannerUrl,
            'posterUrl': posterUrl,
            'vote': vote,
            'launchOn': launchOn,
            'isItMovie': isItMovie
          }
        ])
      });
    } else {
      await removeFromWatchList(movieId);
    }
  }

  //checking if the movie already in watch list
  Future<bool> checkIfAlreadyOnWatchList(int movieId) async {
    try {
      DocumentReference docRef = userCollection.doc(uid);
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData['watchLater'] != null) {
          List<dynamic> watchList = userData['watchLater'];

          bool alreadyOnWatchList =
              watchList.any((movie) => movie['id'] == movieId);

          return alreadyOnWatchList;
        }
      }
      return false;
    } catch (e) {
      log("Error checking if movie exists: $e");
      return false;
    }
  }

  //handling the process of removing a member from watch list
  Future removeFromWatchList(int id) async {
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    try {
      if (snapshot.exists) {
        if (snapshot['watchLater'] != null) {
          List<dynamic> watchList = snapshot['watchLater'];
          List<dynamic> updatedWatchList = [];
          for (var favorite in watchList) {
            if (favorite['id'] != id) {
              updatedWatchList.add(favorite);
            }
          }
          await docRef.update({'watchLater': updatedWatchList});
        }
      }
    } catch (e) {
      log('error deleting favorite');
    }
  }

  // handling the process of gettin the data from firebase
  Future<List> getWatchList() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      List watchList = doc.get('watchLater');
      return watchList;
    } else {
      return [];
    }
  }

  List<String> generatePartialSearchTerms(String fullName) {
    List<String> partialSearchTerms = [];
    String searchTerm = '';

    for (int i = 0; i < fullName.length; i++) {
      searchTerm += fullName[i];
      partialSearchTerms.add(searchTerm);
    }

    return partialSearchTerms;
  }

  //creating custom lists
  Future<void> createList(String username, String listName, String profilePic,
      bool private, String listDescription) async {
    final lowercaseName = listName.toLowerCase();
    final keywords = generatePartialSearchTerms(lowercaseName);
    DocumentReference docRef = await listsCollection.add({
      "adminId": uid,
      "listName": listName,
      "listIcon": profilePic,
      "listId": "",
      "content": [],
      "followers": [],
      "private": private,
      "listDescription": listDescription,
      "keywords": keywords
    });

    await docRef.update({
      "listId": docRef.id,
    });
    DocumentReference userRef = userCollection.doc(uid);
    await userRef.update({
      "createdLists": FieldValue.arrayUnion([docRef.id])
    });
  }

  Future getListSearchResults(String searchText) async {
    Stream results = listsCollection
        .where('private', isEqualTo: false)
        .where('keywords', arrayContains: searchText)
        .snapshots();
    return results;
  }

  //gett the created lists buy user
  Future<List> getCreatedLists() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (snapshot.exists) {
      List createdListIds = snapshot.get('createdLists');
      List createdLists = [];
      for (var id in createdListIds) {
        DocumentSnapshot movieInfo = await listsCollection.doc(id).get();
        createdLists.add(movieInfo);
      }
      return createdLists;
    } else {
      return [];
    }
  }

  Future<void> deleteListsFromListDocuments(String listId) async {
    DocumentReference docRef = listsCollection.doc(listId);
    await docRef.delete();
  }

  Future<void> deleteListsFromCreatedLists(String listId) async {
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot snapshot = await docRef.get();
    await deleteListsFromListDocuments(listId);
    try {
      if (snapshot.exists) {
        if (snapshot['createdLists'] != null) {
          List<dynamic> createdListIds = snapshot['createdLists'];
          List<dynamic> updatedListIds = [];
          for (var id in createdListIds) {
            if (id != listId) {
              updatedListIds.add(id);
            }
          }

          await docRef.update({'createdLists': updatedListIds});
        }
      }
    } catch (e) {
      log('error while trying to delete the list');
    }
  }

  //gett the followed lists buy user
  Future<List> getFollowedLists() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (snapshot.exists) {
      List followedListIds = snapshot.get('followedLists');
      List followedLists = [];
      for (var id in followedListIds) {
        DocumentSnapshot movieInfo = await listsCollection.doc(id).get();
        followedLists.add(movieInfo);
      }
      log(followedLists.length.toString());
      return followedLists;
    } else {
      return [];
    }
  }
}

class CustomListService extends DatabaseService {
  CustomListService(super.uid);

  //checking before if user has already added this movie to their lists
  Future<bool> checkIfAlreadyOnTheList(String listId, int movieId) async {
    try {
      DocumentReference docRef = listsCollection.doc(uid);
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? contentData =
            snapshot.data() as Map<String, dynamic>?;

        if (contentData != null && contentData['content'] != null) {
          List<dynamic> customList = contentData['content'];
          log(customList.toString());

          bool alreadyOnWatchList =
              customList.any((movie) => movie['id'] == movieId);

          return alreadyOnWatchList;
        }
      }
      return false;
    } catch (e) {
      log("Error checking if movie exists: $e");
      return false;
    }
  }

  //adding movies to the custom lists
  Future<String> addMoviesToCustomLists(
    String listId,
    String movieName,
    int movieId,
    String launchOn,
    String posterUrl,
    String vote,
    String bannerUrl,
    String description,
    bool isItMovie,
  ) async {
    DocumentReference docRef = listsCollection.doc(listId);
    final flag = await checkIfAlreadyOnTheList(listId, movieId);
    log(flag.toString());
    if (flag == false) {
      await docRef.update({
        "content": FieldValue.arrayUnion([
          {
            'name': movieName,
            'id': movieId,
            'description': description,
            'bannerUrl': bannerUrl,
            'posterUrl': posterUrl,
            'vote': vote,
            'launchOn': launchOn,
            'isItMovie': isItMovie
          }
        ])
      });

      return "This movie added succesfully";
    } else {
      return "This movie alredy exists in your lis!";
    }
  }

  Future removeContentFromCustomList(String listId, int movieId) async {
    DocumentReference docRef = listsCollection.doc(listId);
    DocumentSnapshot snapshot = await listsCollection.doc(listId).get();
    try {
      if (snapshot.exists) {
        if (snapshot['content'] != null) {
          List<dynamic> customList = snapshot['content'];
          List<dynamic> updatedCustomList = [];
          for (var content in customList) {
            if (content['id'] != movieId) {
              updatedCustomList.add(content);
            }
          }
          await docRef.update({'content': updatedCustomList});
        }
      }
    } catch (e) {
      log('error deleting favorite');
    }
  }

  Future<DocumentSnapshot?> getListDataFromDatabase(String listId) async {
    DocumentSnapshot snapshot = await listsCollection.doc(listId).get();
    if (snapshot.exists) {
      return snapshot;
    } else {
      return null;
    }
  }

  Future<bool> checkIfUserFollowsTheList(
      String currentUserId, String listId) async {
    DocumentSnapshot snapshot = await listsCollection.doc(listId).get();
    if (snapshot.exists && snapshot['followers'] != null) {
      List followers = snapshot['followers'];
      log('currentUser $currentUserId');
      log('list$followers');
      if (followers.contains(currentUserId)) {
        log('database: true');
        return true;
      } else {
        log('database: false');
        return false;
      }
    } else {
      log('database second if: false');

      return false;
    }
  }

  Future handleTheFollowOrUnfollowProcess(
      String currentUserId, String listId) async {
    DocumentReference docRef = listsCollection.doc(listId);
    DocumentReference userDocRef = userCollection.doc(currentUserId);
    DocumentSnapshot userSnapshot = await userDocRef.get();
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists && snapshot['followers'] != null) {
      List followers = snapshot['followers'];
      List followedLists = userSnapshot['followedLists'];
      if (followers.contains(currentUserId)) {
        final updatedFollowersList = [];
        for (var value in followers) {
          if (value != currentUserId) {
            updatedFollowersList.add(value);
          }
        }
        await deleteFollowingListIdFromUser(currentUserId, listId);
        await docRef.update({'followers': updatedFollowersList});
      } else {
        List updatedFollowedLists = followedLists;
        List updatedList = followers;
        updatedList.add(currentUserId);
        updatedFollowedLists.add(listId);
        await docRef.update({'followers': updatedList});
        await userDocRef.update({'followedLists': updatedFollowedLists});
      }
    }
  }

  Future deleteFollowingListIdFromUser(String userId, String listId) async {
    DocumentReference docRef = userCollection.doc(userId);
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists && snapshot['followedLists'] != null) {
      final followedListIds = snapshot['followedLists'];
      List updatedList = [];
      for (var id in followedListIds) {
        if (id != listId) {
          updatedList.add(id);
        }
      }
      docRef.update({'followedLists': updatedList});
    }
  }
}
