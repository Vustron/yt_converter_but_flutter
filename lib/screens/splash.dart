// utils
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

// widgets
import 'package:yt_converter/widgets/splash/components/subtitle.dart';
import 'package:yt_converter/widgets/splash/components/loading.dart';
import 'package:yt_converter/widgets/splash/components/title.dart';
import 'package:yt_converter/widgets/splash/components/logo.dart';

// methods
import 'package:yt_converter/widgets/splash/methods/transition_home.dart';

// splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    transitionHome(context);
  }

  @override
  Widget build(BuildContext context) {
    // ini media query size
    mq = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(children: [
      // logo
      logo(),

      // App Text
      Positioned(
        bottom: mq.height * .28,
        width: mq.width,
        // duration: const Duration(seconds: 1),
        child: Center(
          child: Column(
            children: [
              // title
              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child: title(),
              ),

              // sub title
              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child: subtitle(),
              ),

              // space
              const SizedBox(height: 30),

              // loading
              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child: loading(),
              )
            ],
          ),
        ),
      ),
    ]));
  }
}
