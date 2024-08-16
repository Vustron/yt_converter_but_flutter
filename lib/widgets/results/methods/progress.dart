// utils
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';

// services
import 'package:yt_converter/services/notification.dart';
import 'package:yt_converter/services/download.dart';

// show download progress method
Future<void> showDownloadProgress(
    BuildContext context, WidgetRef ref, String videoUrl, bool isMP3) async {
  //init completer
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
                        LinearPercentIndicator(
                          width: 235.0,
                          lineHeight: 16.0,
                          percent: downloadProgress,
                          backgroundColor: Colors.grey,
                          progressColor: Color.lerp(
                                  Colors.red, Colors.green, downloadProgress) ??
                              Colors.blue,
                          animation: true,
                          animateFromLastPercent: true,
                          center: Text(
                            '${(downloadProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12.0),
                          ),
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
    // Show error notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.showCompletionNotification(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: 'Download Failed',
      body: 'An error occurred during download.',
    );
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
