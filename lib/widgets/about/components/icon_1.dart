// utils
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

// methods
import 'package:yt_converter/widgets/about/methods/launchurl.dart';

Positioned icon_1() {
  return Positioned(
    top: mq.height * .60,
    right: mq.width * .25, // Adjusted for centering
    width: mq.width * .5,
    child: Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: ElevatedButton(
        onPressed: () => launchURL('https://github.com/Vustron'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 60, minWidth: mq.width * .5),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/icons/github.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'GitHub',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
