// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:garbh/chatbot/chatbot.dart';
import 'package:garbh/communityPage/homepage_community.dart';
import 'package:garbh/parent_screens/home_parent.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 0;

  Future<bool> onBackPress() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const HomeScreenParent(),
      const CommunityHomePage(),
      // const ParentDiscoverScreen(),
      const ChatBotPage(),
    ];

    Color redColor = const Color.fromARGB(255, 249, 76, 102);

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          backgroundColor: redColor,
          elevation: 1.0,
          title: const Text(
            "Garbh",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 20.0,
                bottom: 8.0,
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(1.0),
                  child: Hero(
                    tag: "parentimage",
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/parent.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: SizedBox(
          height: 75.0,
          child: GNav(
            tabBorderRadius: 12,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            gap: 8,
            color: Colors.grey[800],
            activeColor: Colors.red,
            iconSize: 28,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.wiredNetwork,
                text: 'Community',
              ),
              GButton(
                icon: LineIcons.rocketChat,
                text: 'GarbhBot',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
