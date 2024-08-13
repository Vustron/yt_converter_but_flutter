//  utils
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

AnimatedTextKit title() {
  return AnimatedTextKit(
    animatedTexts: [
      ColorizeAnimatedText(
        'Yt Converter',
        textStyle: const TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
        colors: [
          const Color.fromARGB(255, 96, 74, 74),
          const Color.fromARGB(255, 27, 240, 255),
        ],
      ),
    ],
  );
}
