// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// methods
import 'package:yt_converter/widgets/results/methods/progress.dart';

Future<void> downloadOptions(
    BuildContext context, String videoUrl, WidgetRef ref) async {
  void showDownloadProgressIfMounted(bool isMP3) {
    if (context.mounted) {
      showDownloadProgress(context, ref, videoUrl, isMP3);
    }
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Download Options',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.music_note, color: Colors.black),
              label: const Text(
                'Download MP3',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.video_library, color: Colors.black),
              label: const Text(
                'Download MP4',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    },
  );

  if (result != null) {
    showDownloadProgressIfMounted(result);
  }
}
