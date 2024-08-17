// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_converter/utils/file_size.dart';
import 'package:yt_converter/utils/truncate.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'dart:io';

// services
import 'package:yt_converter/services/download.dart';

// widgets
import 'package:yt_converter/widgets/downloads/components/downloaded_items.dart';
import 'package:yt_converter/widgets/downloads/components/delete_bg.dart';

// methods
import 'package:yt_converter/widgets/downloads/methods/delete_download.dart';

// types
typedef FutureListStringCallback = Future<List<String>> Function();
typedef FutureVoidCallback = Future<void> Function();

RefreshIndicator downloadList({
  required AsyncSnapshot<List<String>> snapshot,
  required FutureListStringCallback getDownloads,
  required FutureVoidCallback updateDownloads,
  required FutureVoidCallback refreshDownloads,
}) {
  return RefreshIndicator(
    color: Colors.black,
    onRefresh: refreshDownloads,
    child: ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        // get file data
        final filePath = snapshot.data![index];
        final file = File(filePath);
        final fileSize = getFileSize(file);

        return Dismissible(
          key: Key(filePath),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            deleteDownload(filePath, updateDownloads);
          },
          background: deleteBg(),
          child: Consumer(
            builder: (context, ref, child) {
              // init download progress
              final progress = ref.watch(downloadProgressProvider);

              // init truncate
              final truncatedTitle = truncateText(path.basename(filePath), 31);

              return downloadedItems(
                filePath,
                truncatedTitle,
                fileSize,
                progress,
              );
            },
          ),
        );
      },
    ),
  );
}
