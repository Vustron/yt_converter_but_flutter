// utils
import 'package:yt_converter/utils/truncate.dart';
import 'package:flutter/material.dart';

PreferredSize appbar(
  searchQuery, {
  required VoidCallback onHomePressed,
}) {
  // init truncate
  final truncatedQuery = truncateText(searchQuery, 10);

  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Results for "$truncatedQuery"'),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onHomePressed,
              tooltip: 'Home',
            ),
          ],
        ),
      ),
    ),
  );
}
