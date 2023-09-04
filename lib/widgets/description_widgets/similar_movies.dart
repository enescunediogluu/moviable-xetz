// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/go_to_descripton.dart';

class SimilarMovies extends StatelessWidget {
  final List similar;
  const SimilarMovies({super.key, required this.similar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: similar.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ModifiedText(
                  text: 'Recommended',
                  color: Colors.white,
                  size: 23,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemCount: similar.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            goToDescription(context, similar, index);
                          },
                          child: SizedBox(
                            width: 140,
                            child: Column(
                              children: [
                                (similar[index]['poster_path'] != null)
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'https://image.tmdb.org/t/p/w500' +
                                                  similar[index]['poster_path'],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        width: 140,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey[700],
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 60,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ModifiedText(
                                  text: (similar[index]['title'] != null)
                                      ? similar[index]['title']
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
              ],
            )
          : const SizedBox(
              height: 270,
            ),
    );
  }
}
