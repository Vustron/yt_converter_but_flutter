// utils
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

Positioned content() {
  return Positioned(
    bottom: mq.height * .30,
    width: mq.width,
    // duration: const Duration(seconds: 1),
    child: const Center(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Yt Converter is a youtube mp3 and mp4 converter that will convert the videos that you've searched and downloads it on your device.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
