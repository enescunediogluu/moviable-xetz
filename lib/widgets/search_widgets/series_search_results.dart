// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:moviable/utils/text.dart';
import 'package:moviable/widgets/description_widgets/go_to_descripton.dart';

class SeriesSearchResults extends StatelessWidget {
  final List results;
  const SeriesSearchResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return results.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ModifiedText(
                  text: 'Series Results',
                  color: Colors.white,
                  size: 23,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: results.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          goToDescription(context, results, index);
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
                                    image: NetworkImage(results[index]
                                                ['poster_path'] !=
                                            null
                                        ? 'https://image.tmdb.org/t/p/w500' +
                                            results[index]['poster_path']
                                        : 'https://www.juliedray.com/wp-content/uploads/2022/01/sans-affiche.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ModifiedText(
                                text: (results[index]['title'] != null)
                                    ? results[index]['title']
                                    : results[index]['name'],
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
