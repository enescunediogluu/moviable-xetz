import 'dart:developer';
import 'package:flutter/material.dart';
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

  void getWatchListFromFirebase() async {
    final watchLaterList = await database.getWatchList();
    setState(() {
      watchList = watchLaterList;
      log(watchList.toString());
    });
  }

  @override
  void initState() {
    getWatchListFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          watchList.isEmpty
              ? SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const Icon(
                          Icons.repeat,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ModifiedText(
                            text: 'There is nothing to show!',
                            color: Colors.white.withOpacity(0.4),
                            size: 15)
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 220,
                  child: ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    itemCount: watchList.length,
                    itemBuilder: (context, index) {
                      final movieDetails = watchList[index];
                      final String title = movieDetails[
                          'name']; // Replace with the actual key for movie title in the response
                      final String backdropPath = movieDetails['bannerUrl'];
                      // Replace with the actual key for the poster path

                      return GestureDetector(
                        onLongPress: () async {
                          log(movieDetails['id'].toString());
                          await database
                              .removeFromWatchList(movieDetails['id']);

                          setState(() {
                            getWatchListFromFirebase();
                          });
                        },
                        child: Container(
                          width: 230, // Set the width as per your design
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500/$backdropPath'),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(height: 8),
                              ModifiedText(
                                text: title,
                                size: 13,
                                color: Colors.white,
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
}
