import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviable/pages/main/search_page.dart';
import 'package:moviable/widgets/home_widgets/not_released_movies.dart';
import 'package:moviable/widgets/home_widgets/toprated.dart';
import 'package:moviable/widgets/home_widgets/trending.dart';
import 'package:moviable/widgets/home_widgets/tv_shows.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List popularTvShows = [];
  List moviesNotReleased = [];
  final String apiKey = '0377ce78971549737544ab0b8ca86215';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzc3Y2U3ODk3MTU0OTczNzU0NGFiMGI4Y2E4NjIxNSIsInN1YiI6IjY0ZDM1YWZmZGI0ZWQ2MDBjNTVlZTA3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SE2FX61KSu47_zrqh4nedX-ORxZkpLSB2C0EfV37mQI';

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingResults = await tmdbWithCustomLogs.v3.trending.getTrending();

    Map topRatedMoviesResults =
        await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvShowResults = await tmdbWithCustomLogs.v3.tv.getTopRated();
    Map moviesComingSoon = await tmdbWithCustomLogs.v3.movies.getUpcoming();

    setState(() {
      trendingMovies = trendingResults['results'];
      topRatedMovies = topRatedMoviesResults['results'];
      popularTvShows = tvShowResults['results'];
      moviesNotReleased = moviesComingSoon['results'];

      log(topRatedMoviesResults.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          centerTitle: true,
          /* actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.amber,
                child: Icon(Icons.search),
              ),
            )
          ], */
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const TitleWidget()),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          TrendingMovies(trending: trendingMovies),
          TopRated(topRated: topRatedMovies),
          TvShows(tvShows: popularTvShows),
          NotReleasedMovies(notReleased: moviesNotReleased),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Image.asset(
            "assets/moviable_icon.png",
            color: Colors.amber.withOpacity(0.9),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'moviable',
          style: GoogleFonts.titilliumWeb(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
