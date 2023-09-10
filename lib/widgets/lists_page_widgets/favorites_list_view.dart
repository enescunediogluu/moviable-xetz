import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({Key? key}) : super(key: key);

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  List favorites = [];
  final DatabaseService database = DatabaseService();
  List<bool> isSelectedList = [];

  void getFavouritesFromFirebase() async {
    final favouritesList = await database.getFavorites();
    setState(() {
      favorites = favouritesList;
      isSelectedList = List.generate(favorites.length, (index) => false);
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
      backgroundColor: secondaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_outline_outlined,
              size: 32,
              color: primaryColor,
            ),
            SizedBox(
              width: 5,
            ),
            ModifiedText(text: 'Favorites', color: Colors.white, size: 35),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 20,
          ),
          favorites.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 250,
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
                          size: 15),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
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
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final movieDetails = favorites[index];
                      final String title = movieDetails['name'];
                      final String posterPath = movieDetails['posterUrl'];

                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isSelectedList[index] = !isSelectedList[index];
                          });
                        },
                        onTap: () async {
                          if (isSelectedList[index]) {
                            await database
                                .removeFromFavorites(movieDetails['id']);
                            setState(() {
                              getFavouritesFromFirebase();
                            });
                          }
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    height: 280,
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
                                          )
                                        : null),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: ModifiedText(
                                      text: title,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ]),
      ),
    );
  }
}
