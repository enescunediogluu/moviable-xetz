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

  getFavouritesFromFirebase() async {
    final favouritesList = await database.getFavorites();
    setState(() {
      favorites = favouritesList;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavouritesFromFirebase();
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
                            Text(
                              'There is nothing to show!',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
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
                                  Text(
                                    title,
                                    style: const TextStyle(color: Colors.white),
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
