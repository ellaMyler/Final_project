import 'package:flutter/material.dart';
import 'app_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(0, 34, 77, 1),
          selectedItemColor: Color.fromRGBO(255, 32, 78, 1),
          unselectedItemColor:  Color.fromRGBO(160, 21, 62, 1),
        ),
      ),
      home: const app_ui(),
    );
  }
}