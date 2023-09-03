import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/services/auth_service.dart';
import 'package:moviable/services/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  final DatabaseService database = DatabaseService();

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
      backgroundColor: Colors.black,
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
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(profilePic),
                    radius: 70,
                  );
                default:
                  return const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 70,
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ); // You can change this as needed
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: database.getUsername(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              final username = snapshot.data ?? '';
              return Text(
                username,
                style: const TextStyle(fontSize: 25),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(
              Icons.settings,
              color: Colors.amber,
            ),
            shape: Border.symmetric(
                horizontal: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          ListTile(
            title: const Text('Favourites'),
            leading: const Icon(
              Icons.list,
              color: Colors.amber,
            ),
            shape: Border.symmetric(
                horizontal: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: ListTile(
              title: const Text('Log Out'),
              leading: const Icon(
                Icons.settings,
                color: Colors.amber,
              ),
              shape: Border.symmetric(
                  horizontal: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
          ),
        ],
      )),
    );
  }
}
