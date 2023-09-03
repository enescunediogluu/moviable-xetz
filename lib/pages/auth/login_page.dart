import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/auth/register_page.dart';

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
      body: SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 100,
        ),
        const Icon(
          Icons.event_repeat,
          size: 120,
          color: primaryColor,
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
          prefixIcon: const Icon(Icons.lock),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldItem(
          controller: _password,
          hideText: false,
          isItEmail: false,
          prefixIcon: const Icon(Icons.key),
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
                  try {
                    final email = _email.text;
                    final password = _password.text;
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);

                    log(credential.toString());
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
            const Text(
              'Don\'t have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ));
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
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
          cursorColor: Colors.amber,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            label: Text(label),
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: primaryColor.withOpacity(0.8),
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.8),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ));
  }
}
