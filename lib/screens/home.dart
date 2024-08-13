// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:yt_converter/main.dart';

// widgets
import 'package:yt_converter/widgets/home/components/search_videos.dart';
import 'package:yt_converter/widgets/splash/components/logo.dart';
import 'package:yt_converter/widgets/splash/components/title.dart';

// widgets

// home screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // init text controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ini media query size
    mq = MediaQuery.of(context).size;

    final dynamicHeightSuggestion = [
      'ABC',
    ];

    return Scaffold(
        body: Stack(children: [
      logo(),
      // App Text
      Positioned(
        bottom: mq.height * .36,
        width: mq.width,
        // duration: const Duration(seconds: 1),
        child: Center(
          child: Column(
            children: [
              // title
              Animate(
                  effects: const [FadeEffect(), ScaleEffect()], child: title()),

              // space
              const SizedBox(height: 10),

              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child: searchVideos(dynamicHeightSuggestion, _searchController),
              )
            ],
          ),
        ),
      ),

      // App Text
    ]));
  }
}
