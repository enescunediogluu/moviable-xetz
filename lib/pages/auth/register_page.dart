import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
          Icons.movie_creation_outlined,
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
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldItem(
          controller: _password,
          hideText: false,
          isItEmail: false,
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
                onPressed: () {},
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
            const Text(
              'If you have an account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              },
              child: const Text(
                'Login now',
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
