// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:yt_converter/screens/root.dart';

// services
import 'package:yt_converter/services/search.dart';

// widgets
import 'package:yt_converter/widgets/results/components/appbar.dart';

class ResultScreen extends ConsumerWidget {
  // init search query
  final String searchQuery;

  // init result constructor
  const ResultScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // init search state
    final searchState = ref.watch(searchServiceProvider);

    // init search results state
    final searchResults = searchState.videos;

    return Scaffold(
      appBar: appbar(searchQuery, onHomePressed: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: const RootScreen(),
            ));
      }),
      body: searchState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final video = searchResults[index];
                return ListTile(
                  leading: Image.network(video.thumbnailUrl),
                  title: Text(video.title),
                  subtitle: Text(video.channelTitle),
                  onTap: () {
                    // Handle video selection
                  },
                );
              },
            ),
    );
  }
}
