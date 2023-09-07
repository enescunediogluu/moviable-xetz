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
                        builder: (context) => const FavoritesListView(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/favorites_icon.png')),
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WatchListView(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/watch_later_icon.png')),
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
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
                    text: 'Created Lists',
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
                  scrollDirection: Axis.vertical,
                  itemCount: myLists.length,
                  itemBuilder: (context, index) {
                    final listDetails = myLists[index];
                    final posterPath = listDetails['listIcon'];
                    final title = listDetails['listName'];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xff404258),
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: NetworkImage((posterPath != "")
                                      ? posterPath
                                      : 'https://pbs.twimg.com/profile_images/737023860839747584/hDWpm4OB_400x400.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ModifiedText(
                          text: title,
                          color: Colors.white,
                          size: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
