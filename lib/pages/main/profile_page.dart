import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/services/auth_service.dart';
import 'package:moviable/services/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  final DatabaseService database =
      DatabaseService(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  getUsername() async {
    final username = await database.getUsername();
    log(username);
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          FutureBuilder(
            future: database.getProfilePic(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // Change this if needed
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    // Handle error state
                    return Text('Error: ${snapshot.error}');
                  }
                  final profilePic = snapshot.data ?? '';
                  return CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: NetworkImage(profilePic),
                    radius: 70,
                  );
                default:
                  return const CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 70,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ); // You can change this as needed
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          UsernameDisplayWidget(database: database),
          const SizedBox(
            height: 20,
          ),
          logOutOptionTile(),
        ],
      )),
    );
  }

  InkWell logOutOptionTile() {
    return InkWell(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
      },
      child: ListTile(
        title: const Text('Log Out'),
        leading: const Icon(
          Icons.settings,
          color: primaryColor,
        ),
        shape: Border.symmetric(
            horizontal: BorderSide(color: sideColorWhite.withOpacity(0.1))),
      ),
    );
  }
}

class UsernameDisplayWidget extends StatelessWidget {
  const UsernameDisplayWidget({
    super.key,
    required this.database,
  });

  final DatabaseService database;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.getUsername(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        final username = snapshot.data ?? '';
        return Text(
          username,
          style: const TextStyle(fontSize: 25),
        );
      },
    );
  }
}
