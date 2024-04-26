import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'app_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        final view = WidgetsBinding.instance!.window.platformDispatcher;
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness = view.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
        }
      },
      themes: [
        AppTheme(
          id: "light",
          description: "Light Theme",
          data: ThemeData.light().copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(248, 117, 170, 1),
              selectedItemColor: Color.fromRGBO(255, 246, 246, 1),
              unselectedItemColor: Color.fromRGBO(174, 222, 252, 1),
            ),
          ),
          options: MyThemeOptions(const Color.fromRGBO(179, 175, 255, 1.0)),
        ),
        AppTheme(
          id: "dark",
          description: "Dark Theme",
          data: ThemeData.dark().copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(0, 34, 77, 1),
              selectedItemColor: Color.fromRGBO(255, 32, 78, 1),
              unselectedItemColor: Color.fromRGBO(160, 21, 62, 1),
            ),
          ),
          options: MyThemeOptions(const Color.fromRGBO(9, 7, 61, 1)),
        ),
      ],
      child: Builder(
        builder: (themeContext) => MaterialApp(
          theme: ThemeProvider.themeOf(themeContext).data,
          home: const app_ui(),
        ),
      ),
    );
  }
}

// used in everything to set dark mode stuff
class MyThemeOptions implements AppThemeOptions {
  final Color backgroundColor;

  MyThemeOptions(this.backgroundColor);
}
