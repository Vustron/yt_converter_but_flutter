// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_converter/utils/parse_duration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';

// models
import 'package:yt_converter/models/yt_video.dart';

// Define the provider
final searchServiceProvider =
    StateNotifierProvider<SearchService, SearchState>((ref) {
  return SearchService();
});

class SearchState {
  // init list
  final List<YoutubeVideo> videos;

  // init loading state
  final bool isLoading;

  SearchState({required this.videos, required this.isLoading});
}

class SearchService extends StateNotifier<SearchState> {
  // init service
  SearchService() : super(SearchState(videos: [], isLoading: false));

  // search youtube method
  Future<void> searchYouTube(String query) async {
    // init api key
    String? apiKey = dotenv.env['YOUTUBE_API_KEY'];

    // init url
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey');

    // init search state
    state = SearchState(videos: state.videos, isLoading: true);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        final videos =
            items.map((item) => YoutubeVideo.fromJson(item)).toList();

        // Fetch video durations
        for (var i = 0; i < videos.length; i++) {
          final videoId = items[i]['id']['videoId'];
          final durationUrl = Uri.parse(
              'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoId&key=$apiKey');
          final durationResponse = await http.get(durationUrl);

          if (durationResponse.statusCode == 200) {
            final durationData = json.decode(durationResponse.body);
            final duration =
                durationData['items'][0]['contentDetails']['duration'];
            videos[i] = videos[i].copyWith(duration: parseDuration(duration));
          }
        }

        state = SearchState(videos: videos, isLoading: false);
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      developer.log('Error in searchYouTube: $e');
      state = SearchState(
          videos: [], isLoading: false); // Clear the state in case of an error
    }
  }

  // clear search method
  void clearSearch() {
    state = SearchState(videos: [], isLoading: false);
  }
}
