// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_converter/services/download.dart';
import 'package:flutter/material.dart';

Future<void> downloadOptions(
    BuildContext context, String videoId, WidgetRef ref) {
  return showDialog(
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
              onPressed: () {
                ref.read(downloadServiceProvider).downloadMp3(videoId, context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.music_note, color: Colors.black),
              label: const Text(
                'Download MP3',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(downloadServiceProvider).downloadMp4(videoId, context);
                Navigator.pop(context);
              },
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
}
