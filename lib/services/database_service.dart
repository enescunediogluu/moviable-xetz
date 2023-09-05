import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  final uid = FirebaseAuth.instance.currentUser!.uid;

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
  Future<String> updateTheProfilePhoto() async {
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
            'launchOn': launchOn
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
            'launchOn': launchOn
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

  //creating custom lists
  Future createList(String username, String listName) async {
    DocumentReference docRef = await listsCollection.add({
      "adminId": uid,
      "listName": listName,
      "listIcon": "",
      "listId": "",
      "content": [],
      "followers": [],
    });

    await docRef.update({
      "listId": docRef.id,
    });
    DocumentReference userRef = userCollection.doc(uid);
    await userRef.update({
      "createdLists": FieldValue.arrayUnion([docRef.id])
    });
  }
}
