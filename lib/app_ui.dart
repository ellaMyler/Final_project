import 'package:final_project/videos.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:final_project/goals.dart';
import 'package:final_project/settings.dart';
import 'package:final_project/scheduler.dart';
import 'home.dart';
import 'package:provider/provider.dart';

class app_ui extends StatefulWidget {
  const app_ui({Key? key}) : super(key: key);

  @override
  _app_uiState createState() => _app_uiState();
}

class _app_uiState extends State<app_ui> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const Scheduler(),
    const Goals(),
    const Home(),
    const Videos(),
    const Settings(),
  ];


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Define fallback colors
    final Color backgroundColor =
        theme.bottomNavigationBarTheme.backgroundColor ?? Colors.white;
    final Color unselectedItemColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;
    final Color selectedItemColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? Colors.blue;
    bool thingy = context.watch<UserProvider>().isFullScreen;
    // Calculate the height of the bottom navigation bar based on screen width
    double bottomNavBarHeight = MediaQuery.of(context).size.width * 0.17;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Visibility(
        visible: !thingy, // Show bottom navigation bar if isFullScreen is false
        child: SizedBox(
          height: bottomNavBarHeight,
          child: GNav(
            backgroundColor: backgroundColor,
            color: unselectedItemColor,
            activeColor: selectedItemColor,
            gap: 10,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.calendar_month,
                text: 'Plan',
              ),
              GButton(
                icon: Icons.adjust,
                text: 'Goals',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.ondemand_video_sharp,
                text: 'Videos',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}