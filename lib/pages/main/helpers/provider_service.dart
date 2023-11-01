// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/constants/keys.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieProvider extends ChangeNotifier {
  final TMDB _tmdb;
  Map<String, dynamic> _movieData;

  MovieProvider()
      : _tmdb = TMDB(ApiKeys(mainApiKey, mainReadAccessToken)),
        _movieData = {};

  Future<void> loadMovies() async {
    try {
      final trendingResults = await _tmdb.v3.trending.getTrending();
      final topRatedMoviesResults = await _tmdb.v3.movies.getTopRated();
      final tvShowResults = await _tmdb.v3.tv.getTopRated();
      final moviesComingSoon = await _tmdb.v3.movies.getUpcoming();

      _movieData['trendingMovies'] = trendingResults['results'];
      _movieData['topRatedMovies'] = topRatedMoviesResults['results'];
      _movieData['popularTvShows'] = tvShowResults['results'];
      _movieData['moviesNotReleased'] = moviesComingSoon['results'];

      notifyListeners();
    } catch (error) {
      log("Error loading movies: $error");
    }
  }

  Map<String, dynamic> get movieData => _movieData;
}
