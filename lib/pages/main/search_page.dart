// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/search_widgets/movie_search_results.dart';
import 'package:moviable/widgets/search_widgets/series_search_results.dart';
import 'package:tmdb_api/tmdb_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";
  List movieSearchResults = [];
  List serieSearchResults = [];

  final String apiKey = '0377ce78971549737544ab0b8ca86215';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzc3Y2U3ODk3MTU0OTczNzU0NGFiMGI4Y2E4NjIxNSIsInN1YiI6IjY0ZDM1YWZmZGI0ZWQ2MDBjNTVlZTA3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SE2FX61KSu47_zrqh4nedX-ORxZkpLSB2C0EfV37mQI';

  search(String query) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map movieSearch = await tmdbWithCustomLogs.v3.search.queryMovies(query);
    Map serieSearch = await tmdbWithCustomLogs.v3.search.queryTvShows(query);

    setState(() {
      movieSearchResults = movieSearch['results'];
      serieSearchResults = serieSearch['results'];
      log(serieSearchResults.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(25)),
            height: 50,
            child: Center(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    search(searchText);
                  });
                },
                cursorColor: secondaryColor,
                decoration: SearchBarDecoration(),
              ),
            ),
          ),
          searchText.isEmpty
              ? const Opacity(
                  opacity: 0.4,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Icon(
                        Icons.search_off,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ModifiedText(
                        text: 'There is no result yet !',
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                )
              : Container(),
          MovieSearchResults(results: movieSearchResults),
          SeriesSearchResults(results: serieSearchResults)
        ],
      ),
    );
  }

  InputDecoration SearchBarDecoration() {
    return InputDecoration(
      prefixIcon: Icon(
        Icons.search,
        color: secondaryColor.withOpacity(0.8),
      ),
      hintText: 'Search for movies or series',
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: secondaryColor),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
    );
  }
}
