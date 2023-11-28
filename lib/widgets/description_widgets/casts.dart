// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/utils/text.dart';

class CastList extends StatelessWidget {
  final List castList;
  const CastList({super.key, required this.castList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: castList.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ModifiedText(
                  text: 'Cast',
                  color: sideColorWhite,
                  size: 23,
                ),
                const SizedBox(
                  height: 10,
                ),
                castList.isNotEmpty
                    ? SizedBox(
                        height: 270,
                        child: ListView.builder(
                          physics: const ScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemCount: castList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: 140,
                                  child: Column(
                                    children: [
                                      (castList[index]['profile_path'] != null)
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              height: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500' +
                                                        castList[index]
                                                            ['profile_path'],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
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
                                        text: (castList[index]['name'] != null)
                                            ? castList[index]['name']
                                            : 'Loading',
                                        color: sideColorWhite,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      )
                    : SizedBox(
                        height: 30,
                        child: Center(
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.red.withOpacity(0.6),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ModifiedText(
                                text: "Info not found!",
                                color: sideColorWhite.withOpacity(0.6),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            )
          : Container(),
    );
  }
}
