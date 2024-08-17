// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

// services
import 'package:yt_converter/services/download.dart';

Future<void> downloadOptions(
    BuildContext context, String videoUrl, WidgetRef ref) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Animate(
        child: AlertDialog(
          backgroundColor: Colors.white,
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.video_library, color: Colors.black),
                label: const Text(
                  'Download MP4',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 200.ms, curve: Curves.easeInOut),
      );
    },
  );

  if (context.mounted) {
    if (result != null) {
      if (result) {
        await ref.read(downloadServiceProvider).downloadMp3(videoUrl, context);
      } else {
        await ref.read(downloadServiceProvider).downloadMp4(videoUrl, context);
      }
    }
  }
}
