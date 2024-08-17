import 'package:flutter/material.dart';
import 'package:yt_converter/widgets/downloads/methods/icons.dart';
import 'package:yt_converter/widgets/downloads/methods/open_file.dart';

ListTile downloadedItems(
    String filePath, String truncatedTitle, String fileSize, double? progress) {
  return ListTile(
    leading: getFileIcon(filePath),
    title: Text(
      truncatedTitle,
      style: const TextStyle(fontSize: 16),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fileSize,
          style: const TextStyle(fontSize: 12),
        ),
        progress != null
            ? LinearProgressIndicator(value: progress)
            : const Text(
                'Completed',
                style: TextStyle(fontSize: 12),
              ),
      ],
    ),
    onTap: () => openFile(filePath),
  );
}
