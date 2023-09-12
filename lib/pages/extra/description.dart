// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/constants/keys.dart';
import 'package:moviable/pages/main/lists_page.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/casts.dart';
import 'package:moviable/widgets/description_widgets/similar_movies.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Description extends StatefulWidget {
  final String name, description, bannerUrl, posterUrl, vote, launchOn;
  final int id;
  final bool isItMovie;

  const Description({
    super.key,
    required this.name,
    required this.description,
    required this.bannerUrl,
    required this.posterUrl,
    required this.vote,
    required this.launchOn,
    required this.id,
    required this.isItMovie,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  List casts = [];
  List similar = [];
  List genres = [];

  bool isItInFavorites = false;
  bool isItInWatchList = false;
  List myCreatedLists = [];

  final DatabaseService database = DatabaseService();
  final CustomListService customListService = CustomListService();

  @override
  void initState() {
    widget.isItMovie ? loadMovieInformations() : loadTvInformations();
    isItLiked();
    getCreatedListsFromFirebase();
    super.initState();
  }

  getCreatedListsFromFirebase() async {
    final temp = await database.getCreatedLists();
    setState(() {
      myCreatedLists = temp;
      log(myCreatedLists.toString());
    });
  }

  loadMovieInformations() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map movieInfo = await tmdbWithCustomLogs.v3.movies.getDetails(widget.id);
    log(movieInfo.toString());
    Map movieCredits = await tmdbWithCustomLogs.v3.movies.getCredits(widget.id);

    Map similarResultsMovies =
        await tmdbWithCustomLogs.v3.movies.getRecommended(widget.id);

    setState(() {
      casts = movieCredits["cast"];
      similar = similarResultsMovies["results"];
    });
  }

  loadTvInformations() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map tvCredits = await tmdbWithCustomLogs.v3.tv.getCredits(widget.id);
    Map similarResultsTv =
        await tmdbWithCustomLogs.v3.tv.getRecommendations(widget.id);

    setState(() {
      casts = tvCredits["cast"];
      similar = similarResultsTv["results"];
    });
  }

  isItLiked() async {
    final value = await database.checkIfAlreadyLiked(widget.id);
    setState(() {
      isItInFavorites = value;
    });
  }

  String formatTheVote(String word) {
    if (word.length > 3) {
      return word.substring(0, 3);
    } else if (word == '0') {
      return 'Not Voted';
    } else if (word == '0.0') {
      return 'Not Voted';
    } else {
      return word;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                (widget.bannerUrl != 'null')
                    ? BannerImageWidget(widget: widget)
                    : const ImagePlaceholderWidget(),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleTextWidget(widget: widget),
                RatingContainerWidget()
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          DescriptionTextWidget(
            widget: widget,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FavoritesButton(),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 20,
              ),
              WatchLaterButton(),
              AddToPlaylistButton(
                customList: myCreatedLists,
                movieName: widget.name,
                movieId: widget.id,
                isItMovie: widget.isItMovie,
                posterUrl: widget.posterUrl,
                bannerUrl: widget.bannerUrl,
                launchOn: widget.launchOn,
                vote: widget.vote,
                description: widget.description,
              ),
            ],
          ),
          CastList(castList: casts),
          SimilarMovies(similar: similar),
        ],
      ),
    );
  }

  IconButton FavoritesButton() {
    return IconButton(
        onPressed: () async {
          await database.addOrDeleteFavorites(
              widget.name,
              widget.id,
              widget.description,
              widget.bannerUrl,
              widget.posterUrl,
              widget.vote,
              widget.launchOn);

          setState(() {
            isItInFavorites = !isItInFavorites;
          });
        },
        icon: isItInFavorites
            ? const Icon(
                Icons.favorite,
                color: Colors.amber,
                size: 35,
              )
            : const Icon(
                Icons.favorite_outline,
                color: Colors.amber,
                size: 35,
              ));
  }

  Container RatingContainerWidget() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.black,
          ),
          Text(
            formatTheVote(widget.vote),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  InkWell WatchLaterButton() {
    return InkWell(
      onTap: () async {
        await database.addOrDeleteWatchListItems(
          widget.name,
          widget.id,
          widget.description,
          widget.bannerUrl,
          widget.posterUrl,
          widget.vote,
          widget.launchOn,
        );

        setState(() {
          isItInWatchList = !isItInWatchList;
        });
      },
      child: Container(
        width: 170,
        decoration: BoxDecoration(
            color: isItInWatchList ? Colors.amber : const Color(0xffCDF0EA),
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(15))),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            isItInWatchList
                ? const Icon(
                    Icons.done,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.timer,
                    color: Colors.black,
                  ),
            const SizedBox(
              width: 10,
            ),
            isItInWatchList
                ? const ModifiedText(
                    color: Colors.black,
                    size: 16,
                    text: 'on WatchList',
                  )
                : const ModifiedText(
                    color: Colors.black,
                    size: 16,
                    text: 'Watch Later',
                  )
          ],
        ),
      ),
    );
  }
}

class AddToPlaylistButton extends StatefulWidget {
  final String movieName;
  final int movieId;
  final String posterUrl;
  final String bannerUrl;
  final String launchOn;
  final String description;
  final String vote;
  final bool isItMovie;

  final List customList;
  const AddToPlaylistButton({
    super.key,
    required this.customList,
    required this.movieName,
    required this.movieId,
    required this.posterUrl,
    required this.bannerUrl,
    required this.launchOn,
    required this.description,
    required this.vote,
    required this.isItMovie,
  });

  @override
  State<AddToPlaylistButton> createState() => _AddToPlaylistButtonState();
}

class _AddToPlaylistButtonState extends State<AddToPlaylistButton> {
  final DatabaseService database = DatabaseService();
  final CustomListService customListService = CustomListService();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff7FBCD2),
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(10)))),
        onPressed: () {
          showModalBottomSheet(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            context: context,
            builder: (context) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ModifiedText(
                              text: 'Add to a list',
                              color: Colors.white,
                              size: 30),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: GeneralListWidget(
                          lists: widget.customList,
                          color: Colors.white,
                          onTap: (id) async {
                            final message =
                                await customListService.addMoviesToCustomLists(
                              id,
                              widget.movieName,
                              widget.movieId,
                              widget.launchOn,
                              widget.posterUrl,
                              widget.vote,
                              widget.bannerUrl,
                              widget.description,
                              widget.isItMovie,
                            );

                            Navigator.of(context).pop();
                            log(message);
                          },
                          onLongPress: (id) async {},
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            Icons.add,
            color: secondaryColor,
          ),
        ),
      ),
    );
  }
}

class BannerImageWidget extends StatelessWidget {
  const BannerImageWidget({
    super.key,
    required this.widget,
  });

  final Description widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          widget.bannerUrl,
          fit: BoxFit.cover,
        ));
  }
}

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        child: Image.asset(
          'assets/movie_icon.png',
          color: Colors.black,
        ));
  }
}

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.widget,
  });

  final Description widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      alignment: Alignment.topLeft,
      child: HeaderText(
        text: widget.name,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class DescriptionTextWidget extends StatelessWidget {
  const DescriptionTextWidget({
    super.key,
    required this.widget,
  });

  final Description widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: HeaderText(
        text: widget.description,
        color: Colors.white.withOpacity(0.6),
        size: 16,
      ),
    );
  }
}
