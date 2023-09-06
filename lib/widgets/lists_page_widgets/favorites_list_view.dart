import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({super.key});

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  List favorites = [];
  final DatabaseService database = DatabaseService();

  void getFavouritesFromFirebase() async {
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
      body: Column(children: [
        const SizedBox(
          height: 60,
        ),
        favorites.isEmpty
            ? SizedBox(
                height: 300,
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
            : SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
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
                        await database.removeFromFavorites(movieDetails['id']);

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
      ]),
    );
  }
}
