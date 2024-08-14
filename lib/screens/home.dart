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

  // init focus node
  final FocusNode _searchFocusNode = FocusNode();

  //  init search focus
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

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

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchServiceProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    // ini media query size
    mq = MediaQuery.of(context).size;

    // init search
    final searchState = ref.watch(searchServiceProvider);
    final searchResults = searchState.videos;

    return GestureDetector(
      onTap: () {
        _clearSearch();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: mq.height,
            child: Stack(
              children: [
                logo(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.only(
                      top: 100,
                      bottom: _isSearchFocused ? 0 : mq.height * 0.001),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isSearchFocused) ...[
                          Animate(
                            effects: const [FadeEffect(), ScaleEffect()],
                            child: title(),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Animate(
                          effects: const [FadeEffect(), ScaleEffect()],
                          child: searchVideos(
                            _searchFieldKey,
                            searchResults.map((video) => video.title).toList(),
                            _searchController,
                            focusNode: _searchFocusNode,
                            onSearch: _onSearch,
                            onClear: _clearSearch,
                            onFocus: _clearSearch,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
