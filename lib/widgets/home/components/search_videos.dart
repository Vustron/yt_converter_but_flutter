// utils
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:yt_converter/main.dart';

Container searchVideos(
    GlobalKey key, List<String> suggestions, TextEditingController controller,
    {required Function(String) onSearch, required Function() onClear}) {
  return Container(
    width: mq.width * 0.8,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: SearchField(
      key: key,
      controller: controller,
      hint: 'Search videos',
      searchInputDecoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            controller.clear();
            onClear();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      ),
      suggestionStyle: const TextStyle(color: Colors.black),
      suggestionsDecoration: SuggestionDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      maxSuggestionBoxHeight: 300,
      dynamicHeight: true,
      suggestions: suggestions.map(SearchFieldListItem<String>.new).toList(),
      suggestionState: Suggestion.expand,
      onSuggestionTap: (suggestion) {
        onSearch(suggestion.searchKey);
      },
      onSubmit: (value) {
        onSearch(value);
      },
    ),
  );
}
