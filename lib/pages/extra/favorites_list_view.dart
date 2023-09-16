// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/extra/description.dart';
import 'package:moviable/pages/main/navbar_trial.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({Key? key}) : super(key: key);

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  List favorites = [];
  final DatabaseService database =
      DatabaseService(FirebaseAuth.instance.currentUser!.uid);
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
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavbarTrial(
                    definedIndex: 2,
                  ),
                ),
                (route) => false);
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
            height: 10,
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
                  height: MediaQuery.of(context).size.height - 120,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final movieDetails = favorites[index];
                      final String title = movieDetails['name'];
                      final String posterUrl = movieDetails['posterUrl'];
                      final String bannerUrl = movieDetails['bannerUrl'];
                      final int id = movieDetails['id'];
                      final String description = movieDetails['description'];
                      final bool isItMovie = movieDetails['isItMovie'];
                      final String vote = movieDetails['vote'];
                      final String launchOn = movieDetails['launchOn'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Description(
                                name: title,
                                description: description,
                                bannerUrl: bannerUrl,
                                posterUrl: posterUrl,
                                vote: vote,
                                launchOn: launchOn,
                                id: id,
                                isItMovie: isItMovie),
                          ));
                        },
                        onLongPress: () {
                          setState(() {
                            isSelectedList[index] = !isSelectedList[index];
                          });
                        },
                        child: Container(
                          width: 150,
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
                                            'https://image.tmdb.org/t/p/w500/$posterUrl'),
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
                                                      context, index, id);
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
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: ModifiedText(
                                  text: title,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(
            height: 25,
          )
        ]),
      ),
    );
  }

  showDeleteDialog(BuildContext context, dynamic index, int id) async {
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
                  text: 'Are you sure you want to remove it from favorites?',
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
                      onPressed: () async {
                        if (isSelectedList[index]) {
                          await database.removeFromFavorites(id);
                          setState(() {
                            getFavouritesFromFirebase();
                          });

                          Navigator.of(context).pop();
                        }
                      },
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
