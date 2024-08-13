// utils
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// screens
import 'package:yt_converter/screens/root.dart';

// transition to home method
Future<void> transitionHome(BuildContext context) {
  return Future.delayed(const Duration(milliseconds: 3000), () async {
    // Exit full-screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
    Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          child: const RootScreen(),
        ));
  });
}
