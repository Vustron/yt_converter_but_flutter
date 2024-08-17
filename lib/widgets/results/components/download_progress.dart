// utils
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

// services
import 'package:yt_converter/services/download.dart';

class DownloadProgressSection extends ConsumerWidget {
  // init keys
  const DownloadProgressSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // init download state
    final downloadState = ref.watch(downloadProgressProvider);

    if (downloadState == null) {
      return const SizedBox.shrink();
    }

    return Animate(
        child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Downloading...',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 48,
            lineHeight: 16.0,
            percent: downloadState,
            backgroundColor: Colors.grey,
            progressColor:
                Color.lerp(Colors.red, Colors.green, downloadState) ??
                    Colors.blue,
            animation: true,
            animateFromLastPercent: true,
            center: Text(
              '${(downloadState * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12.0),
            ),
            barRadius: const Radius.circular(10),
          ),
        ],
      ),
    )).scale(duration: 300.ms, curve: Curves.easeInOut);
  }
}
