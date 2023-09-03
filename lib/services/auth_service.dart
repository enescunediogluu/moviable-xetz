import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviable/services/auth_user.dart';
import 'package:moviable/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //handling the email verification
  Future<void> sentEmailVerification() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      log('Email verification has failed!');
    }
  }

  //handling the login process
  Future loginWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  Future registerWithEmailandPassword(
    String username,
    String email,
    String password,
    String profilePic,
  ) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // call our database service to update the user data.
      await DatabaseService().savingUserData(username, email, profilePic);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
