// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final DatabaseService database = DatabaseService();

  List favorites = [];
  List watchList = [];

  void getFavouritesFromFirebase() async {
    final favouritesList = await database.getFavorites();
    setState(() {
      favorites = favouritesList;
    });
  }

  void getWatchListFromFirebase() async {
    final watchLaterList = await database.getWatchList();
    setState(() {
      watchList = watchLaterList;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavouritesFromFirebase();
    getWatchListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Row(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(
                    width: 10,
                  ),
                  ModifiedText(
                    text: 'Favourites',
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              favorites.isEmpty
                  ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            const Icon(
                              Icons.heart_broken,
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
                  : Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        scrollDirection: Axis.horizontal,
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final movieDetails = favorites[index];
                          final String title = movieDetails[
                              'name']; // Replace with the actual key for movie title in the response
                          final String posterPath = movieDetails['posterUrl'];
                          // Replace with the actual key for the poster path

                          return GestureDetector(
                            onLongPress: () async {
                              log(movieDetails['id'].toString());
                              await database
                                  .removeFromFavorites(movieDetails['id']);

                              setState(() {
                                getFavouritesFromFirebase();
                              });
                            },
                            child: Container(
                              width: 150, // Set the width as per your design
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Container(
                                    height: 230,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500/$posterPath'),
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
              const Row(
                children: [
                  Icon(
                    Icons.watch_later,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ModifiedText(
                    text: 'Watch List',
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                  : Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
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
          )),
    );
  }
}
