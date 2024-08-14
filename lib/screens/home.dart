// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yt_converter/main.dart';
import 'package:flutter/material.dart';

// screens
import 'package:yt_converter/screens/results.dart';

// services
import 'package:yt_converter/services/search.dart';

// widgets
import 'package:yt_converter/widgets/home/components/search_videos.dart';
import 'package:yt_converter/widgets/splash/components/title.dart';
import 'package:yt_converter/widgets/splash/components/logo.dart';

// home screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // init text controller
  final TextEditingController _searchController = TextEditingController();

  // init search field key
  final GlobalKey _searchFieldKey = GlobalKey();

  void _onSearch(String query) {
    ref.read(searchServiceProvider.notifier).searchYouTube(query);
    Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          child: ResultScreen(searchQuery: query),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // ini media query size
    mq = MediaQuery.of(context).size;

    // init search
    final searchState = ref.watch(searchServiceProvider);
    final searchResults = searchState.videos;

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

              // search videos
              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child: searchVideos(
                  _searchFieldKey,
                  searchResults.map((video) => video.title).toList(),
                  _searchController,
                  onSearch: _onSearch,
                  onClear: () {
                    ref.read(searchServiceProvider.notifier).clearSearch();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
