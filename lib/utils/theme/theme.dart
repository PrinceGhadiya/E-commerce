import 'package:flutter/material.dart';

class KAppTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Colors.lightBlue[100]!,
      ),
      textTheme: TextTheme(
        labelMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
      ));
}
