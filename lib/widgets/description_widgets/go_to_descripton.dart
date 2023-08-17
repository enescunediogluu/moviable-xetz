// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviable/pages/main/description.dart';

void goToDescription(context, List<dynamic> list, index) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Description(
      name: (list[index]['title'] != null)
          ? list[index]['title']
          : list[index]['name'],
      description:
          (list[index]['overview'] != null) ? list[index]['overview'] : 'null',
      bannerUrl: ((list[index]['backdrop_path'] != null)
          ? 'https://image.tmdb.org/t/p/w500' + list[index]['backdrop_path']
          : 'null'),
      posterUrl: ((list[index]['poster_path'] != null)
          ? 'https://image.tmdb.org/t/p/w500' + list[index]['poster_path']
          : 'null'),
      vote: list[index]['vote_average'].toString(),
      launchOn: (list[index]['release_date'] != null)
          ? list[index]['release_date']
          : list[index]['first_air_date'],
      id: list[index]['id'],
    ),
  ));

  log(list[index].toString());
}
