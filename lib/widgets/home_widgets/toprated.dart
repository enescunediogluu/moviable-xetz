// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/go_to_descripton.dart';

class TopRated extends StatelessWidget {
  final List topRated;
  const TopRated({super.key, required this.topRated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Top Rated Movies',
            color: Colors.white,
            size: 23,
          ),
          const SizedBox(
            height: 10,
          ),
          topRated.isNotEmpty
              ? SizedBox(
                  height: 270,
                  child: ListView.builder(
                    itemCount: topRated.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            goToDescription(context, topRated, index);
                          },
                          child: SizedBox(
                            width: 140,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            topRated[index]['poster_path'],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ModifiedText(
                                  text: (topRated[index]['title'] != null)
                                      ? topRated[index]['title']
                                      : 'Loading',
                                  color: Colors.white,
                                  size: 15,
                                )
                              ],
                            ),
                          ));
                    },
                  ),
                )
              : SizedBox(
                  height: 270,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
