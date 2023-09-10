// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
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
      floatingActionButton: Padding(
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
      ),
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
              Container(
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
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
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
                                  image:
                                      AssetImage('assets/favorites_icon.png')),
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const ModifiedText(
                            text: 'Favorites', color: Colors.white, size: 20)
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 15,
                    thickness: 3,
                    color: primaryColor,
                  ),
                  InkWell(
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
                                  image: AssetImage(
                                      'assets/watch_later_icon.png')),
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const ModifiedText(
                            text: 'Watch List', color: Colors.white, size: 20)
                      ],
                    ),
                  ),
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
                          ),
                          GeneralListWidget(
                            lists: myLists,
                            color: const Color(0xff222831),
                            onLongPress: unfollowList,
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

unfollowList(String id) {}

class GeneralListWidget extends StatelessWidget {
  const GeneralListWidget({
    super.key,
    required this.lists,
    required this.color,
    required this.onLongPress,
  });

  final List lists;
  final Color color;
  final Function(String id) onLongPress;

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
            onLongPress: () => onLongPress(listDetails['listId']),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      image: DecorationImage(
                          image: NetworkImage((posterPath != "")
                              ? posterPath
                              : 'https://pbs.twimg.com/profile_images/737023860839747584/hDWpm4OB_400x400.jpg'),
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
