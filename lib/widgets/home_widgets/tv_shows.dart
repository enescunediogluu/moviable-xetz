// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/go_to_descripton.dart';

class TvShows extends StatelessWidget {
  final List tvShows;
  const TvShows({super.key, required this.tvShows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Top Rated Series',
            color: Colors.white,
            size: 23,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              itemCount: tvShows.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    goToDescription(context, tvShows, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 260,
                    child: Column(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500' +
                                    tvShows[index]['backdrop_path'],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ModifiedText(
                          text: (tvShows[index]['name'] != null)
                              ? tvShows[index]['name']
                              : 'Loading',
                          color: Colors.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
