import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/main/helpers/provider_service.dart';
import 'package:moviable/widgets/home_widgets/not_released_movies.dart';
import 'package:moviable/widgets/home_widgets/toprated.dart';
import 'package:moviable/widgets/home_widgets/trending.dart';
import 'package:moviable/widgets/home_widgets/tv_shows.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List popularTvShows = [];
  List moviesNotReleased = [];

  @override
  void initState() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (movieProvider.movieData.isEmpty) {
      // Fetch data only if it hasn't been fetched before
      movieProvider.loadMovies();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    // Access data using movieProvider.movieData
    final trendingMovies = movieProvider.movieData['trendingMovies'];
    final topRatedMovies = movieProvider.movieData['topRatedMovies'];
    final popularTvShows = movieProvider.movieData['popularTvShows'];
    final moviesNotReleased = movieProvider.movieData['moviesNotReleased'];

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const TitleWidget()),
      body: ListView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          const SizedBox(
            height: 20,
          ),
          if (trendingMovies != null && trendingMovies.isNotEmpty)
            TrendingMovies(trending: trendingMovies),
          if (topRatedMovies != null && topRatedMovies.isNotEmpty)
            TopRated(topRated: topRatedMovies),
          if (popularTvShows != null && popularTvShows.isNotEmpty)
            TvShows(tvShows: popularTvShows),
          if (moviesNotReleased != null && moviesNotReleased.isNotEmpty)
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
        const SizedBox(
            height: 40,
            child: Icon(
              Icons.movie,
              color: Colors.amber,
              size: 30,
            )),
        const SizedBox(
          width: 10,
        ),
        Text(
          'moviable',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ],
    );
  }
}
