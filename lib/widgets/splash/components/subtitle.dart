//  utils
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

AnimatedTextKit subtitle() {
  return AnimatedTextKit(
    animatedTexts: [
      WavyAnimatedText(
        'Made by Vustron',
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
        speed: const Duration(milliseconds: 70),
      ),
    ],
  );
}
