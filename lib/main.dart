import 'package:flutter/material.dart';
import 'package:moviable/pages/auth/login_page.dart';

void main() {
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
      home: const LoginPage(),
    );
  }
}
