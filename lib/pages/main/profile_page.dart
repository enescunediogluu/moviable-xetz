import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 70,
            child: Icon(
              Icons.person,
              size: 70,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'enescunedioglu',
            style: TextStyle(fontSize: 25),
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
            title: const Text('Log Out'),
            leading: const Icon(
              Icons.settings,
              color: Colors.amber,
            ),
            shape: Border.symmetric(
                horizontal: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
        ],
      )),
    );
  }
}
