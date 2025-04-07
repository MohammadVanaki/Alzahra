import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: "Bloomberg",
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Bloomberg",
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    ),
    highlightColor: Colors.indigo,
    canvasColor: Colors.grey,
    unselectedWidgetColor: Colors.white70,
    primaryColorLight: const Color.fromRGBO(252, 178, 98, 1),
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.amber.shade800,
    indicatorColor: Colors.amber,
    secondaryHeaderColor: const Color.fromRGBO(176, 106, 2, 1),
    iconTheme: IconThemeData(color: Colors.amber.shade800),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.red,
      selectionColor: Colors.green,
      selectionHandleColor: Colors.blue,
    ),
    colorScheme: const ColorScheme.dark(),
    fontFamily: 'Bloomberg',
  );

  static final lightTheme = ThemeData(
    textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontFamily: "Bloomberg", fontSize: 20, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(
          fontFamily: "Bloomberg", fontSize: 15, fontWeight: FontWeight.w400),
    ),
    highlightColor: Colors.grey,
    unselectedWidgetColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: const Color.fromARGB(255, 6, 82, 79).withAlpha(50),
    ),
    primaryColorLight: const Color.fromARGB(255, 1, 84, 88),
    primaryColor: const Color.fromARGB(255, 6, 82, 79),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.amber,
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 1, 84, 88),
    ),
    secondaryHeaderColor: const Color.fromRGBO(176, 106, 2, 1),
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 211, 169, 64)),
    fontFamily: 'Bloomberg',
  );
}
