// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/extra/create_lists_page.dart';
import 'package:moviable/pages/extra/custom_lists_content_page.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/pages/extra/favorites_list_view.dart';
import 'package:moviable/pages/extra/watch_list_view.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final DatabaseService database = DatabaseService();

  List myLists = [];
  String listName = "";

  getCreatedListsFromFirebase() async {
    final temp = await database.getCreatedLists();
    setState(() {
      myLists = temp;
    });
  }

  deleteLists(String listId) {
    database.deleteListsFromCreatedLists(listId);
    setState(() {
      myLists.removeWhere((list) => list['listId'] == listId);
      //try to understand this code part
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
      floatingActionButton: const FloatingActionButtonWidget(),
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const ListPageSearchbarWidget(),
              const SizedBox(
                height: 25,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FavoritesButtonWidget(),
                  VerticalDivider(
                    width: 15,
                    thickness: 3,
                    color: primaryColor,
                  ),
                  WatchlistButtonWidget(),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              DefaultTabController(
                length: 2, // Number of tabs (Created Lists and Following Lists)
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          child: ModifiedText(
                            color: Colors.white,
                            text: 'Your Lists',
                            size: 15,
                          ),
                        ),
                        Tab(
                          child: ModifiedText(
                            color: Colors.white,
                            text: 'Following',
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 500, // Adjust the height as needed
                      child: TabBarView(
                        children: [
                          GeneralListWidget(
                            lists: myLists,
                            color: const Color(0xff222831),
                            onLongPress: deleteLists,
                            onTap: (id) {
                              goToListPage(context, id);
                            },
                          ),
                          GeneralListWidget(
                            lists: myLists,
                            color: const Color(0xff222831),
                            onLongPress: unfollowList,
                            onTap: (id) {
                              goToListPage(context, id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchlistButtonWidget extends StatelessWidget {
  const WatchlistButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WatchListView(),
        ));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/watch_later_icon.png')),
                borderRadius: BorderRadius.circular(25)),
          ),
          const SizedBox(
            height: 10,
          ),
          const ModifiedText(text: 'Watch List', color: Colors.white, size: 20)
        ],
      ),
    );
  }
}

class FavoritesButtonWidget extends StatelessWidget {
  const FavoritesButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FavoritesListView(),
        ));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/favorites_icon.png')),
                borderRadius: BorderRadius.circular(25)),
          ),
          const SizedBox(
            height: 10,
          ),
          const ModifiedText(text: 'Favorites', color: Colors.white, size: 20)
        ],
      ),
    );
  }
}

class ListPageSearchbarWidget extends StatelessWidget {
  const ListPageSearchbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: secondaryColor.withOpacity(0.8),
          ),
          ModifiedText(
              text: 'Search lists...',
              color: secondaryColor.withOpacity(0.8),
              size: 15)
        ],
      )),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateListsPage(),
          ));
        },
        child: const Icon(
          Icons.add,
          color: secondaryColor,
          size: 30,
        ),
      ),
    );
  }
}

class GeneralListWidget extends StatelessWidget {
  const GeneralListWidget({
    super.key,
    required this.lists,
    required this.color,
    required this.onLongPress,
    required this.onTap,
  });

  final List lists;
  final Color color;
  final Function(String id) onLongPress;
  final void Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          final listDetails = lists[index];
          final posterPath = listDetails['listIcon'];
          final title = listDetails['listName'];
          return InkWell(
            onTap: () => onTap(listDetails['listId']),
            onLongPress: () => onLongPress(listDetails['listId']),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff252B48),
                      Color(0xff445069),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      image: DecorationImage(
                          image: NetworkImage((posterPath != "")
                              ? posterPath
                              : 'https://i.pinimg.com/564x/c1/ae/86/c1ae864b0ea941be0362c6d45fad10af.jpg'),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  child: HeaderText(
                    text: title,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

goToListPage(BuildContext context, String id) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CustomListsContentPage(listId: id),
  ));
}

unfollowList(String id) {}
