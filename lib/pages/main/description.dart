import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/casts.dart';
import 'package:moviable/widgets/description_widgets/similar_movies.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Description extends StatefulWidget {
  final String name, description, bannerUrl, posterUrl, vote, launchOn;
  final int id;

  const Description({
    super.key,
    required this.name,
    required this.description,
    required this.bannerUrl,
    required this.posterUrl,
    required this.vote,
    required this.launchOn,
    required this.id,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  List casts = [];
  List similar = [];
  List genres = [];
  final String apiKey = '0377ce78971549737544ab0b8ca86215';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzc3Y2U3ODk3MTU0OTczNzU0NGFiMGI4Y2E4NjIxNSIsInN1YiI6IjY0ZDM1YWZmZGI0ZWQ2MDBjNTVlZTA3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SE2FX61KSu47_zrqh4nedX-ORxZkpLSB2C0EfV37mQI';
  final DatabaseService database = DatabaseService();
  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));
    Map credits = await tmdbWithCustomLogs.v3.movies.getCredits(widget.id);
    Map similarResults =
        await tmdbWithCustomLogs.v3.movies.getRecommended(widget.id);

    setState(() {
      casts = credits["cast"];
      similar = similarResults["results"];
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
          IconButton(
              onPressed: () async {
                await database.addItToTheFavourites(
                    widget.name,
                    widget.id,
                    widget.description,
                    widget.bannerUrl,
                    widget.posterUrl,
                    widget.vote,
                    widget.launchOn);
                log(widget.id.toString());
              },
              icon: const Icon(
                Icons.favorite_outline,
                color: Colors.amber,
              )),
          CastList(castList: casts),
          SimilarMovies(similar: similar),
        ],
      ),
    );
  }
}
