// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yt_converter/utils/truncate.dart';
import 'package:flutter/material.dart';

// services
import 'package:yt_converter/services/search.dart';

// screens
import 'package:yt_converter/screens/root.dart';

// widgets
import 'package:yt_converter/widgets/results/components/download_progress.dart';
import 'package:yt_converter/widgets/results/components/result_item.dart';
import 'package:yt_converter/widgets/results/components/appbar.dart';

class ResultScreen extends ConsumerWidget {
  final String searchQuery;

  const ResultScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchServiceProvider);
    final searchResults = searchState.videos;

    return Scaffold(
      appBar: appbar(searchQuery, onHomePressed: () {
        ref.read(searchServiceProvider.notifier).clearSearch();
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: const RootScreen(),
          ),
        );
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: searchState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final video = searchResults[index];
                          final truncatedTitle = truncateText(video.title, 24);

                          return resultItem(
                              video, truncatedTitle, context, ref);
                        },
                      ),
              ),
              const SizedBox(
                height: 80,
                child: DownloadProgressSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
