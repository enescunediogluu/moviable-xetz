// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/pages/extra/create_lists_page.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/lists_page_widgets/favorites_list_view.dart';
import 'package:moviable/widgets/lists_page_widgets/watch_list_view.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final DatabaseService database = DatabaseService();

  List myLists = [];
  String listName = "";
  bool _isLoading = false;

  getCreatedListsFromFirebase() async {
    final temp = await database.getCreatedLists();
    setState(() {
      myLists = temp;
      log(myLists.toString());
    });
  }

  @override
  void initState() {
    super.initState();

    getCreatedListsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CreateListsPage(),
            ));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FavoritesListView(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          color: const Color(0xffB1B2FF),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 100,
                            color: Colors.black,
                          ),
                          ModifiedText(
                              text: 'Favorites', color: Colors.black, size: 18)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WatchListView(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          color: Color(0xffFFF6BD),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later,
                            size: 100,
                            color: Colors.black,
                          ),
                          ModifiedText(
                              text: 'WatchList', color: Colors.black, size: 18)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.list,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ModifiedText(
                    text: 'My Lists',
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  itemCount: myLists.length,
                  itemBuilder: (context, index) {
                    final listDetails = myLists[index];
                    final posterPath = listDetails['listIcon'];
                    final title = listDetails['listName'];
                    return Column(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: 240,
                        height: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                                image: NetworkImage((posterPath != "")
                                    ? posterPath
                                    : 'https://pbs.twimg.com/profile_images/737023860839747584/hDWpm4OB_400x400.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      ModifiedText(
                        text: title,
                        color: Colors.white,
                        size: 13,
                      ),
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 0,
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : TextField(
                          onChanged: (value) {
                            setState(() {
                              listName = value;
                            });
                          },
                          cursorColor: Theme.of(context).secondaryHeaderColor,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.add,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            hintText: "New Group Name",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateListsPage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
