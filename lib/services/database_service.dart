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

  Future addItToTheFavourites(
    String name,
    int movieId,
    String description,
    String bannerUrl,
    String posterUrl,
    String vote,
    String launchOn,
  ) async {
    DocumentReference docRef = userCollection.doc(uid);
    final flag = await checkIfMovieExists(movieId);
    if (flag == false) {
      await docRef.update({
        "favourites": FieldValue.arrayUnion([
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
      log('You already have it on your list!');
    }
  }

  //chat gpt made it
  Future<bool> checkIfMovieExists(int movieId) async {
    try {
      // Reference to the user's document in Firestore (replace 'uid' with the actual user ID).
      DocumentReference docRef = userCollection.doc(uid);

      // Fetch the user's document data.
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        // The user document exists.

        // Cast the data to a Map<String, dynamic>.
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;

        // Check if 'favourites' field is present and not null.
        if (userData != null && userData['favourites'] != null) {
          List<dynamic> favorites = userData['favourites'];

          // Use any() to check if any movie in the favorites list has the same 'id'.
          bool movieExists = favorites.any((movie) => movie['id'] == movieId);

          return movieExists;
        }
      }

      // The user document does not exist or 'favourites' field is null.
      return false;
    } catch (e) {
      // Handle any errors that occur during the Firestore query.
      log("Error checking if movie exists: $e");
      return false;
    }
  }

  Future<List> getFavourites() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      List favourites = doc.get('favourites');
      return favourites;
    } else {
      return [];
    }
  }
}
