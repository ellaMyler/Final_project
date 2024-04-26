import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State

{

  late bool _isDarkModeEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    });
  }

  void _toggleDarkMode(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkModeEnabled', darkMode);
    setState(() {
      _isDarkModeEnabled = darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dark Mode'),
              Switch(
                value: _isDarkModeEnabled,
                onChanged: _toggleDarkMode,
              ),
// You can add more settings widgets here
            ],
          ),
        ),
      ),
    );
  }
}