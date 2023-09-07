import 'package:flutter/material.dart';
import 'package:moviable/pages/main/lists_page.dart';
import 'package:moviable/pages/main/main_page.dart';
import 'package:moviable/pages/main/profile_page.dart';
import 'package:moviable/pages/main/search_page.dart';

class NavbarTrial extends StatefulWidget {
  final int definedIndex;
  const NavbarTrial({super.key, this.definedIndex = 0});

  @override
  State<NavbarTrial> createState() => _NavbarTrialState();
}

class _NavbarTrialState extends State<NavbarTrial> {
  int selectedIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const ListsPage(),
    const ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.definedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Colors.amber.withOpacity(0.1),
              width: 1,
            )),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber,
            onTap: onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.list),
                label: 'Lists',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.person),
                label: 'Profile',
              )
            ],
          ),
        ));
  }
}
