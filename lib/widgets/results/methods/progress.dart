import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:yt_converter/services/download.dart';

Future<void> showDownloadProgress(
    BuildContext context, WidgetRef ref, String videoUrl, bool isMP3) async {
  final completer = Completer<void>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(
            isMP3 ? 'Downloading MP3' : 'Downloading MP4',
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          content: Consumer(
            builder: (context, ref, _) {
              final progress = ref.watch(downloadProgressProvider(videoUrl));
              final isPreparing = progress == null;
              final downloadProgress = progress ?? 0.0;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPreparing)
                    const Column(
                      children: [
                        CircularProgressIndicator(color: Colors.blue),
                        SizedBox(height: 16),
                        Text('Preparing download...'),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: downloadProgress,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.lerp(Colors.red, Colors.green,
                                        downloadProgress) ??
                                    Colors.blue,
                              ),
                            ),
                            Text(
                              '${(downloadProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Downloading... ${(downloadProgress * 100).toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      );
    },
  );

  try {
    if (isMP3) {
      await ref.read(downloadServiceProvider).downloadMp3(videoUrl, context);
    } else {
      await ref.read(downloadServiceProvider).downloadMp4(videoUrl, context);
    }
  } catch (e) {
    log('Download error: $e');
  } finally {
    completer.complete();
  }

  await completer.future;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  });
}
