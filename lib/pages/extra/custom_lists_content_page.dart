// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/pages/extra/description.dart';
import 'package:moviable/pages/extra/list_settings_page.dart';
import 'package:moviable/services/auth_service.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class CustomListsContentPage extends StatefulWidget {
  final String listId;

  const CustomListsContentPage({
    super.key,
    required this.listId,
  });

  @override
  State<CustomListsContentPage> createState() => _CustomListsContentPageState();
}

class _CustomListsContentPageState extends State<CustomListsContentPage> {
  final AuthService authService = AuthService();

  final CustomListService customListService =
      CustomListService(AuthService().currentUser!.id);
  String currentUserId = "";
  String listName = "";
  String listIcon = "";
  String adminId = "";
  String listDescription = "";
  bool private = true;
  List followers = [];
  List contents = [];
  List<bool> isSelectedList = [];
  bool isUserAdmin = false;
  bool isUserFollowingTheList = false;

  getCurrentUser() async {
    final temp = authService.currentUser!.id;
    setState(() {
      currentUserId = temp;
    });
  }

  getListInfoFromDatabase() async {
    final info = await customListService.getListDataFromDatabase(widget.listId);
    final value = await customListService.checkIfUserFollowsTheList(
        currentUserId, widget.listId);
    if (info != null) {
      log('snapshot is not null');

      setState(() {
        listName = info['listName'];
        listIcon = info['listIcon'];
        adminId = info['adminId'];
        followers = info['followers'];
        contents = info['content'];
        isSelectedList = List.generate(contents.length, (index) => false);
        private = info['private'];
        listDescription = info['listDescription'];

        isUserAdmin = info['adminId'] == currentUserId;
        isUserFollowingTheList = value;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getListInfoFromDatabase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: (listIcon != "")
                                    ? DecorationImage(
                                        image: NetworkImage(listIcon),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage(
                                            'assets/watch_later_icon.png'),
                                        fit: BoxFit.cover)),
                          ),
                          Container(
                            color: secondaryColor,
                            height: 90,
                          )
                        ],
                      ),
                      Positioned(
                        top: 65,
                        left: 20,

                        // Adjust the left position as needed
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 40,
                            sigmaY: 40,
                          ),
                          child: HeaderDisplayWidget(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ModifiedText(
                                text: followers.length.toString(),
                                color: Colors.white,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              const ModifiedText(
                                text: 'Followers',
                                color: Colors.white,
                                size: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              ModifiedText(
                                text: contents.length.toString(),
                                color: Colors.white,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              const ModifiedText(
                                text: 'Content',
                                color: Colors.white,
                                size: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isUserAdmin
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: sideColorWhite),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ListSettingsPage(
                                  listId: widget.listId,
                                  listName: listName,
                                  listIcon: listIcon,
                                  description: listDescription,
                                  private: private,
                                ),
                              ));
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: secondaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ModifiedText(
                                  text: 'Settings',
                                  color: secondaryColor,
                                  size: 15,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: isUserFollowingTheList
                                    ? primaryColor
                                    : sideColorWhite),
                            onPressed: () async {
                              await customListService
                                  .handleTheFollowOrUnfollowProcess(
                                      currentUserId, widget.listId);

                              setState(() {
                                getListInfoFromDatabase();
                              });
                            },
                            child: Row(
                              children: [
                                isUserFollowingTheList
                                    ? const Icon(
                                        Icons.done,
                                        color: secondaryColor,
                                      )
                                    : const Icon(
                                        Icons.ads_click,
                                        color: secondaryColor,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ModifiedText(
                                  text: isUserFollowingTheList
                                      ? 'Following'
                                      : 'Follow',
                                  color: isUserFollowingTheList
                                      ? secondaryColor
                                      : secondaryColor,
                                  size: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            )),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ContentListviewBuilder()
              ],
            ),
            const ReturnNavigationButton()
          ],
        ),
      ),
    );
  }

  Row HeaderDisplayWidget(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: (listIcon != "")
                ? NetworkImage(
                    listIcon,
                  )
                : const NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/moviable-xetz-app.appspot.com/o/backdrop_empty.jpg?alt=media&token=60d795f9-abfa-49c5-bd3a-e4335ccd372a'),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: primaryColor)),
            child: ModifiedText(
              text: private ? 'Private' : 'Public',
              color: Colors.white,
              size: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      const SizedBox(
        width: 20,
      ),
      Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: HeaderText(
              text: listName,
              color: Colors.white,
              size: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: HeaderText(
              text: listDescription,
              color: Colors.white.withOpacity(0.6),
              size: 12,
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    ]);
  }

  SizedBox ContentListviewBuilder() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 250,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final details = contents[index];
          final description = details['description'];
          final posterUrl = details['posterUrl'];
          final bannerUrl = details['bannerUrl'];
          final vote = details['vote'];
          final name = details['name'];
          final movieId = details['id'];
          final launchOn = details['launchOn'];
          final isItMovie = details['isItMovie'];

          return PressableContentContainer(index, context, name, description,
              bannerUrl, posterUrl, vote, launchOn, movieId, isItMovie);
        },
      ),
    );
  }

  InkWell PressableContentContainer(int index, BuildContext context, name,
      description, bannerUrl, posterUrl, vote, launchOn, movieId, isItMovie) {
    return InkWell(
      highlightColor: Colors.red.withOpacity(0.2),
      onLongPress: () {
        setState(() {
          isSelectedList[index] = !isSelectedList[index];
        });
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Description(
              name: name,
              description: description,
              bannerUrl: bannerUrl,
              posterUrl: posterUrl,
              vote: vote,
              launchOn: launchOn,
              id: movieId,
              isItMovie: isItMovie),
        ));
      },
      child: ContentDisplayContainer(bannerUrl, name, index, context, movieId),
    );
  }

  Stack ContentDisplayContainer(
      bannerUrl, name, int index, BuildContext context, movieId) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient:
              LinearGradient(colors: [Color(0xff282A3A), Color(0xff404258)]),
        ),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(15)),
                  image: DecorationImage(
                      image: NetworkImage(
                        bannerUrl,
                      ),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 220,
              child: HeaderText(text: name, color: Colors.white, size: 15),
            ),
          ],
        ),
      ),
      isSelectedList[index]
          ? DeleteMovieWhenPressedIcon(context, index, movieId)
          : Positioned(child: Container())
    ]);
  }

  Positioned DeleteMovieWhenPressedIcon(
      BuildContext context, int index, movieId) {
    return Positioned(
      right: 30,
      bottom: 22,
      child: CircleAvatar(
        backgroundColor: Colors.red.withOpacity(0.8),
        child: IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                context: context,
                builder: (context) {
                  return DeleteBottomMessage(context, index, movieId);
                },
              );

              setState(() {
                isSelectedList[index] = false;
              });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            )),
      ),
    );
  }

  Container DeleteBottomMessage(BuildContext context, int index, movieId) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_forever,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              ModifiedText(text: 'Delete', color: Colors.white, size: 30)
            ],
          ),
          const ModifiedText(
              text: 'Are you sure you want to remove it from this list?',
              color: Colors.white,
              size: 15),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const ModifiedText(
                      text: 'Cancel', color: secondaryColor, size: 15)),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    if (isSelectedList[index]) {
                      await customListService.removeContentFromCustomList(
                          widget.listId, movieId);
                      setState(() {
                        getListInfoFromDatabase();
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const ModifiedText(
                      text: 'Delete', color: secondaryColor, size: 15))
            ],
          ),
        ],
      ),
    );
  }
}

class ReturnNavigationButton extends StatelessWidget {
  const ReturnNavigationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 2,
        top: 30,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }
}
