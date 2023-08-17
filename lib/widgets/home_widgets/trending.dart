// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/go_to_descripton.dart';

class TrendingMovies extends StatelessWidget {
  final List trending;
  const TrendingMovies({super.key, required this.trending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Trending',
            color: Colors.white,
            size: 23,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 270,
            width: double.infinity,
            child: trending.isNotEmpty
                ? CarouselSlider.builder(
                    itemCount: trending.length,
                    itemBuilder: (context, index, realIndex) {
                      return InkWell(
                        onTap: () {
                          goToDescription(context, trending, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500' +
                                    trending[index]['poster_path'],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 270,
                      autoPlay: true,
                      enlargeFactor: 0.4,
                      viewportFraction: 0.50,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      enlargeCenterPage: true,
                    ))
                : SizedBox(
                    height: 300,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )),
                  ),
          )
        ],
      ),
    );
  }
}
