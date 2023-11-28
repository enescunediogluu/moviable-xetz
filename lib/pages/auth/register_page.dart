// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/auth/login_page.dart';
import 'package:moviable/pages/auth/verify_email_page.dart';
import 'package:moviable/services/auth_service.dart';
import 'package:moviable/utils/text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;
  final AuthService authService = AuthService();

  String profilePic = "";

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const HeaderText(
                text: 'Register',
                color: sideColorWhite,
                size: 40,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 10,
              ),
              ModifiedText(
                  text: "Create an account and join the party!",
                  color: sideColorWhite.withOpacity(0.4),
                  size: 15)
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 50,
        ),
        TextFieldItem(
          controller: _username,
          hideText: false,
          keyboardType: TextInputType.emailAddress,
          isItEmail: false,
          prefixIcon: const Icon(Icons.person_2, color: Colors.amber),
          label: 'Username',
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldItem(
          controller: _email,
          hideText: false,
          keyboardType: TextInputType.emailAddress,
          isItEmail: true,
          label: 'Email',
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.amber,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldItem(
          controller: _password,
          hideText: true,
          isItEmail: false,
          prefixIcon: const Icon(Icons.key, color: Colors.amber),
          label: 'Password',
        ),
        const SizedBox(
          height: 50,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.deepOrangeAccent,
                        Colors.amber,
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  final username = _username.text;

                  final userCredentials =
                      authService.registerWithEmailandPassword(
                          username, email, password, profilePic);

                  log(userCredentials.toString());

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerifyEmailPage(),
                  ));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: scaffoldBackgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ModifiedText(
                text: "If you already have an account",
                color: sideColorWhite,
                size: 13),
            TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                },
                child: const ModifiedText(
                  text: "Login",
                  color: primaryColor,
                  size: 15,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ])),
    );
  }
}
