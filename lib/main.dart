import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moviable/firebase_options.dart';
import 'package:moviable/pages/auth/login_page.dart';
import 'package:moviable/pages/auth/verify_email_page.dart';
import 'package:moviable/pages/main/navbar_trial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber,
          scaffoldBackgroundColor: const Color(0xff191A19)),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            log('there is no user');
            // User is not authenticated, show LoginPage
            return const LoginPage();
          } else {
            log(user.emailVerified.toString());
            if (user.emailVerified == true) {
              return const NavbarTrial();
            } else {
              return const VerifyEmailPage();
            }
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
