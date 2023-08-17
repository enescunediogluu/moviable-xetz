import 'dart:developer';

import 'package:flutter/material.dart';
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
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        search(searchText);
                      });
                    },
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      hintText: 'Search for movies or series',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4)),
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          MovieSearchResults(results: movieSearchResults),
          SeriesSearchResults(results: serieSearchResults)
        ],
      ),
    );
  }
}
