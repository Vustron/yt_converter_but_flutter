// utils
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:yt_converter/main.dart';

Positioned image() {
  return Positioned(
    top: mq.height * .10,
    right: mq.width * .25,
    width: mq.width * .5,
    child: Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(30), // Match the container's radius
          child: Image.asset('assets/images/vustron.png'),
        ),
      ),
    ),
  );
}
