// utils
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yt_converter/main.dart';

Positioned logo() {
  return Positioned(
    top: mq.height * .25,
    right: mq.width * .25,
    width: mq.width * .5,
    // duration: const Duration(seconds: 1),
    child: Animate(
        effects: const [FadeEffect(), ScaleEffect()],
        child: Image.asset('assets/icons/icon.png')),
  );
}
