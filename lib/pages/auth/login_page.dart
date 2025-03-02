// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/auth/register_page.dart';
import 'package:moviable/pages/main/navbar_trial.dart';
import 'package:moviable/utils/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                text: "Sign In",
                color: sideColorWhite,
                size: 40,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 10,
              ),
              ModifiedText(
                  text: "Welcome back!",
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
          controller: _email,
          hideText: false,
          keyboardType: TextInputType.emailAddress,
          isItEmail: true,
          label: 'Email',
          prefixIcon: const Icon(
            Icons.lock,
            color: primaryColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldItem(
          controller: _password,
          hideText: false,
          isItEmail: false,
          prefixIcon: const Icon(
            Icons.key,
            color: primaryColor,
          ),
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
                        primaryColor,
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: sideColorWhite,
                ),
                onPressed: () async {
                  try {
                    final email = _email.text;
                    final password = _password.text;
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => NavbarTrial(),
                        ),
                        (root) => false);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      log('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      log('Wrong password provided for that user.');
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: Text(
                    'Login',
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
              text: "Create an account",
              color: sideColorWhite,
              size: 14,
            ),
            TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ));
                },
                child: ModifiedText(
                  text: "Register",
                  color: primaryColor.withOpacity(0.8),
                  size: 15,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ])),
    );
  }
}

class TextFieldItem extends StatelessWidget {
  final TextEditingController controller;
  final bool hideText;
  final TextInputType? keyboardType;
  final bool isItEmail;
  final String label;
  final Widget prefixIcon;

  const TextFieldItem(
      {super.key,
      required this.controller,
      required this.hideText,
      required this.isItEmail,
      required this.label,
      required this.prefixIcon,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          enableSuggestions: false,
          obscureText: hideText,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            label: Text(label),
            labelStyle: TextStyle(color: sideColorWhite.withOpacity(0.6)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: primaryColor.withOpacity(0.8),
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: sideColorWhite.withOpacity(0.8),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle: TextStyle(
              color: sideColorWhite.withOpacity(0.3),
            ),
          ),
        ));
  }
}
