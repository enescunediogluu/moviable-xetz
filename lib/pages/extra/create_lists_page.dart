import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/main/navbar_trial.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class CreateListsPage extends StatefulWidget {
  const CreateListsPage({super.key});

  @override
  State<CreateListsPage> createState() => _CreateListsPageState();
}

class _CreateListsPageState extends State<CreateListsPage> {
  String description = "";
  String listName = "";
  String profilePic = "";
  bool isLoading = false;
  bool private = true;
  bool isDescriptionSelected = false;
  final DatabaseService database =
      DatabaseService(FirebaseAuth.instance.currentUser!.uid);

  uploadProfilePhoto() async {
    setState(() {
      isLoading = true;
    });
    final tempUrl = await database.uploadProfilePhotoAndGetUrl();
    setState(() {
      profilePic = tempUrl;
      log(profilePic);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NavbarTrial(
                  definedIndex: 2, // Set the selectedIndex to 2
                ),
              ),
              (route) => false, // Remove all routes from the stack
            );
          },
        ),
        centerTitle: true,
        title: const ModifiedText(
            text: 'Create List', color: Colors.white, size: 35),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(children: [
              InkWell(
                onTap: () async {
                  if (profilePic == "") {
                    uploadProfilePhoto();
                  } else {
                    await database.deleteImageFromFirebase(profilePic);
                    uploadProfilePhoto();
                  }
                },
                child: (profilePic != "")
                    ? CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 60,
                        backgroundImage: NetworkImage(profilePic),
                      )
                    : isLoading
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const CircleAvatar(
                            backgroundColor: Color(0xffCDF0EA),
                            radius: 60,
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                            )),
              ),
              (profilePic != "")
                  ? Positioned(
                      right: 1,
                      bottom: 1,
                      child: CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.8),
                          child: IconButton(
                            onPressed: () async {
                              await database
                                  .deleteImageFromFirebase(profilePic);
                              setState(() {
                                profilePic = "";
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          )),
                    )
                  : const SizedBox(
                      width: 1,
                      height: 1,
                    )
            ]),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                cursorColor: primaryColor,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.movie),
                    prefixIconColor: primaryColor,
                    hintText: "Please enter a name",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: sideColorGrey),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(15))),
                onChanged: (value) {
                  setState(() {
                    listName = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                maxLength: 160,
                cursorColor: primaryColor,
                maxLines: 3,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.description),
                    prefixIconColor: primaryColor,
                    hintText: "Please enter a description",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: sideColorGrey),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(15))),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  private = !private;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 40,
                    decoration: BoxDecoration(
                        color: private
                            ? const Color(0xffCDF0EA)
                            : const Color(0xffCDF0EA).withOpacity(0.3),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.lock, color: Colors.black),
                        ModifiedText(
                            text: 'Private', color: Colors.black, size: 15)
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 40,
                    decoration: BoxDecoration(
                        color: private
                            ? const Color(0xffFBA1B7).withOpacity(0.3)
                            : const Color(0xffFBA1B7),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(8))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ModifiedText(
                          text: 'Public',
                          color: Colors.black,
                          size: 15,
                        ),
                        Icon(Icons.public, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () async {
                  if (listName != "") {
                    final username = await database.getUsername();
                    await database.createList(
                        username, listName, profilePic, private, description);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const NavbarTrial(
                          definedIndex: 2, // Set the selectedIndex to 2
                        ),
                      ),
                      (route) => false, // Remove all routes from the stack
                    );
                  }
                },
                child: const SizedBox(
                  height: 45,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.create,
                        color: Colors.black,
                      ),
                      ModifiedText(
                          text: 'Create', color: Colors.black, size: 20)
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
