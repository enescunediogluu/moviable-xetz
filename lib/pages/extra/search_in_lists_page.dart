import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class SearchInListsPage extends StatefulWidget {
  const SearchInListsPage({Key? key}) : super(key: key);

  @override
  State<SearchInListsPage> createState() => _SearchInListsPageState();
}

class _SearchInListsPageState extends State<SearchInListsPage> {
  final DatabaseService database =
      DatabaseService(FirebaseAuth.instance.currentUser!.uid);
  String searchText = "";
  late Stream<QuerySnapshot> results;

  getAllPublicListsFromFirebase() async {
    final temp = await database.getListSearchResults(searchText);
    setState(() {
      results = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllPublicListsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            searchBarWidget(),
            StreamBuilder(
              stream: results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: primaryColor,
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  log('An error occurred: ${snapshot.error}');
                  return const Text('An error occurred.');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.dangerous,
                              color: primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ModifiedText(
                                text: 'There is no results yet!',
                                color: sideColorWhite.withOpacity(0.6),
                                size: 15),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];
                      final listName = document['listName'];
                      final listIcon = document['listIcon'];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff252B48),
                                  Color(0xff445069),
                                ]),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15)),
                                image: DecorationImage(
                                    image: NetworkImage((listIcon != "")
                                        ? listIcon
                                        : 'https://i.pinimg.com/564x/c1/ae/86/c1ae864b0ea941be0362c6d45fad10af.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: HeaderText(
                                text: listName,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container searchBarWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(25)),
      height: 50,
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              searchText = value.toLowerCase();
            });
            getAllPublicListsFromFirebase();
          },
          cursorColor: secondaryColor,
          decoration: searchBarDecoration(),
        ),
      ),
    );
  }

  InputDecoration searchBarDecoration() {
    return InputDecoration(
      labelStyle: const TextStyle(color: secondaryColor),
      prefixIcon: Icon(
        Icons.search,
        color: secondaryColor.withOpacity(0.8),
      ),
      hintText: 'Search for lists',
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: secondaryColor),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
    );
  }
}
