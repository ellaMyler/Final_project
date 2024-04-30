import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'authentication.dart';
import 'login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State {
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
// Use ThemeProvider to update the theme based on the user's preference
    ThemeController controller = ThemeProvider.controllerOf(context);
    controller.setTheme(darkMode ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => MaterialApp(
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
                SizedBox(height: 50),
                TextButton.icon(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure you want to log out?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    AuthenticationHelper()
                                        .signOut()
                                        .then((_) =>
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (contex) => Login())));
                                  },
                                  child: Text("Logout"),
                                ),
                              ],
                            );
                          },
                      );
                    },
                  icon: Icon(Icons.logout),
                  label: Text ('Logout',),
                ),
// You can add more settings widgets here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
