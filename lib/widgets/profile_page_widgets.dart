// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:moviable/services/database_service.dart';

@immutable
class UpdateProfilePicWidget extends StatelessWidget {
  String profilePic;
  UpdateProfilePicWidget({super.key, required this.profilePic});

  final DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 60,
          child: Icon(
            Icons.person,
            size: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
          child: GestureDetector(
            onTap: () async {
              profilePic = await database.uploadProfilePhotoAndGetUrl();
            },
            child: const CircleAvatar(
              backgroundColor:
                  Colors.deepOrangeAccent, // Change the color as needed
              radius: 20, // Adjust the size as needed
              child: Icon(
                Icons.edit, // You can change this icon to a pen icon
                size: 20, // Adjust the size as needed
                color: Colors.white, // Change the color as needed
              ),
            ),
          ),
        ),
      ],
    );
  }
}
