import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> sentEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      log('Email verification has failed!');
    }
  }
}
