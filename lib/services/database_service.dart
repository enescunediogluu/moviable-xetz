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
}
