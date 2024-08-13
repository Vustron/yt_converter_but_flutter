// utils
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

Positioned label() {
  return Positioned(
    bottom: mq.height * .50,
    width: mq.width,
    // duration: const Duration(seconds: 1),
    child: const Center(
      child: Column(
        children: [
          Text(
            "Made by Vustron",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          )
        ],
      ),
    ),
  );
}
