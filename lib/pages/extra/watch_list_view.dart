// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {
  List watchList = [];
  final DatabaseService database = DatabaseService();
  List<bool> isSelectedList = [];

  void getWatchListFromFirebase() async {
    final watchLaterList = await database.getWatchList();
    setState(() {
      watchList = watchLaterList;
      isSelectedList = List.generate(watchList.length, (index) => false);
    });
  }

  removeFromWatchList(int index, int id) async {
    if (isSelectedList[index]) {
      await database.removeFromWatchList(id);
      setState(() {
        getWatchListFromFirebase();
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    getWatchListFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.watch_later_outlined,
              size: 32,
              color: primaryColor,
            ),
            SizedBox(
              width: 5,
            ),
            ModifiedText(
              text: 'Watch List',
              size: 35,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          watchList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 250,
                      ),
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ModifiedText(
                          text: 'There is nothing to show!',
                          color: Colors.white.withOpacity(0.4),
                          size: 15),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 5,
                    ),
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: watchList.length,
                    itemBuilder: (context, index) {
                      final movieDetails = watchList[index];
                      final String title = movieDetails[
                          'name']; // Replace with the actual key for movie title in the response
                      final String posterPath = movieDetails['posterUrl'];
                      final int id = movieDetails['id'];
                      // Replace with the actual key for the poster path

                      return GestureDetector(
                        onLongPress: () async {
                          setState(() {
                            isSelectedList[index] = !isSelectedList[index];
                          });
                        },
                        child: Container(
                          width: 150, // Set the width as per your design
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    height: 270,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500/$posterPath'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: isSelectedList[index]
                                        ? BackdropFilter(
                                            filter: isSelectedList[index]
                                                ? ImageFilter.blur(
                                                    sigmaX: 3, sigmaY: 3)
                                                : ImageFilter.blur(),
                                            child: Center(
                                              child: InkWell(
                                                onTap: () async {
                                                  await showDeleteDialog(
                                                    context,
                                                    index,
                                                    id,
                                                    () async {
                                                      await removeFromWatchList(
                                                          index, id);
                                                    },
                                                  );
                                                  setState(() {
                                                    isSelectedList[index] =
                                                        false;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: primaryColor
                                                      .withOpacity(0.8),
                                                  radius: 25,
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 40,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : null),
                              ),
                              const SizedBox(height: 5),
                              Center(
                                child: ModifiedText(
                                  text: title,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  showDeleteDialog(
    BuildContext context,
    dynamic index,
    int id,
    void Function()? function,
  ) async {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_forever,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ModifiedText(text: 'Delete', color: Colors.white, size: 30),
                ],
              ),
              const ModifiedText(
                  text: 'Are you sure you want to remove it from watch list?',
                  color: Colors.white,
                  size: 15),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const ModifiedText(
                          text: 'Cancel', color: secondaryColor, size: 15)),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: function,
                      child: const ModifiedText(
                          text: 'Delete', color: secondaryColor, size: 15))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
