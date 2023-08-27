import 'package:flutter/material.dart';
import 'package:moviable/pages/main/main_page.dart';
import 'package:moviable/pages/main/search_page.dart';

class NavbarTrial extends StatefulWidget {
  const NavbarTrial({super.key});

  @override
  State<NavbarTrial> createState() => _NavbarTrialState();
}

class _NavbarTrialState extends State<NavbarTrial> {
  int selectedIndex = 0;

  List<Widget> pages = [const HomePage(), const SearchPage()];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
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
              color: Colors.amber.withOpacity(0.3),
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
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
          ),
        ));
  }
}
