// utils
import 'package:flutter/material.dart';

// app bar theme config method
AppBarTheme appBarConfig() {
  return const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
  );
}
