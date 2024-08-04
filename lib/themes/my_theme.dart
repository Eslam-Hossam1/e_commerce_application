import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData customeTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ));
}
