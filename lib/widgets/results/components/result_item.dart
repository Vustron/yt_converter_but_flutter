// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// models
import 'package:yt_converter/models/yt_video.dart';

// methods
import 'package:yt_converter/widgets/results/methods/download_options.dart';

ListTile resultItem(YoutubeVideo video, String truncatedTitle,
    BuildContext context, WidgetRef ref) {
  return ListTile(
    leading: Image.network(video.thumbnailUrl),
    title: Text(
      truncatedTitle,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      video.channelTitle,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
      ),
    ),
    onTap: () {
      String videoUrl = 'https://www.youtube.com/watch?v=${video.videoId}';
      downloadOptions(context, videoUrl, ref);
    },
  );
}
