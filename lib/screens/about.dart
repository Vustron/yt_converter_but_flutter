// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

// widgets
import 'package:yt_converter/widgets/about/components/appbar.dart';
import 'package:yt_converter/widgets/about/components/content.dart';
import 'package:yt_converter/widgets/about/components/image.dart';
import 'package:yt_converter/widgets/about/components/label.dart';

// about screen
class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    // init media query size
    mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: appbar(context),
        body: Stack(children: [
          // image
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: image(),
          ),

          // label
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: label(),
          ),

          // content
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: content(),
          ),
        ]));
  }
}
