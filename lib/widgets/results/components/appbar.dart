// utils
import 'package:yt_converter/utils/truncate.dart';
import 'package:flutter/material.dart';

AppBar appbar(
  searchQuery, {
  required VoidCallback onHomePressed,
}) {
  // init truncate
  final truncatedQuery = truncateText(searchQuery, 10);

  return AppBar(
    title: Text('Results for "$truncatedQuery"'),
    centerTitle: true,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
    actions: [
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onHomePressed,
        tooltip: 'Home',
      ),
    ],
  );
}
