import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class CreateListsPage extends StatefulWidget {
  const CreateListsPage({super.key});

  @override
  State<CreateListsPage> createState() => _CreateListsPageState();
}

class _CreateListsPageState extends State<CreateListsPage> {
  String listName = "";
  String profilePic = "";
  bool isLoading = false;
  bool private = true;
  final DatabaseService database = DatabaseService();

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
            Navigator.of(context).pop();
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
                              color: Colors.amber,
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
                          backgroundColor: Colors.amber.withOpacity(0.8),
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
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.movie),
                    prefixIconColor: Colors.amber,
                    hintText: "Please enter a name",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(15))),
                onChanged: (value) {
                  setState(() {
                    listName = value;
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (listName != "") {
                    final username = await database.getUsername();
                    await database.createList(
                        username, listName, profilePic, private);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
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
