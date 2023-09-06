import 'package:flutter/material.dart';
import 'package:moviable/constants/keys.dart';
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

  final DatabaseService database = DatabaseService();

  @override
  void initState() {
    widget.isItMovie ? loadMovieInformations() : loadTvInformations();
    isItLiked();
    super.initState();
  }

  loadMovieInformations() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));
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
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                (widget.bannerUrl != 'null')
                    ? SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          widget.bannerUrl,
                          fit: BoxFit.cover,
                        ))
                    : Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: Image.asset(
                          'assets/movie_icon.png',
                          color: Colors.black,
                        )),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.topLeft,
                  child: HeaderText(
                    text: widget.name,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                      Text(
                        formatTheVote(widget.vote),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: HeaderText(
              text: widget.description,
              color: Colors.white.withOpacity(0.6),
              size: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
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
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.amber,
                        )),
              InkWell(
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
                      color: isItInWatchList
                          ? Colors.amber
                          : const Color(0xffCDF0EA),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
              )
            ],
          ),
          CastList(castList: casts),
          SimilarMovies(similar: similar),
        ],
      ),
    );
  }
}
