// utils
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_converter/utils/sanitize_filename.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

// services
import 'package:yt_converter/services/notification.dart';

// download progress provider
final downloadProgressProvider =
    StateNotifierProvider<DownloadProgressNotifier, double?>(
        (ref) => DownloadProgressNotifier());

class DownloadProgressNotifier extends StateNotifier<double?> {
  // init progress notifier
  DownloadProgressNotifier() : super(null);

  // progress method
  void setProgress(double progress) {
    state = progress;
  }

  // reset method
  void reset() {
    state = null;
  }
}

// Define provider
final downloadServiceProvider = Provider((ref) => DownloadService(ref));

class DownloadService {
  // init ref
  final Ref _ref;

  // init youtube explode
  final YoutubeExplode _yt;

  // init download service
  DownloadService(this._ref) : _yt = YoutubeExplode();

  // request permission method
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      var statusStorage = await Permission.storage.status;
      if (!statusStorage.isGranted) {
        statusStorage = await Permission.storage.request();
      }

      // Add this check for Android 10 (API level 29) and above
      if (await Permission.manageExternalStorage.isRestricted) {
        var statusManageStorage = await Permission.manageExternalStorage.status;
        if (!statusManageStorage.isGranted) {
          statusManageStorage =
              await Permission.manageExternalStorage.request();
        }
        return statusManageStorage.isGranted;
      }

      return statusStorage.isGranted;
    }
    return true;
  }

  // save downloads record method
  Future<void> _saveDownloadRecord(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? downloads = prefs.getStringList('downloads');
    downloads = downloads ?? [];
    downloads.add(filePath);
    await prefs.setStringList('downloads', downloads);
  }

  // get downloads method
  Future<List<String>> getDownloadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('downloads') ?? [];
  }

  // download mp3 method
  Future<void> downloadMp3(String videoUrl, BuildContext context) async {
    await _download(videoUrl, context, true);
  }

  // download mp4 method
  Future<void> downloadMp4(String videoUrl, BuildContext context) async {
    await _download(videoUrl, context, false);
  }

  // download options method
  Future<void> _download(
      String videoUrl, BuildContext context, bool isMP3) async {
    try {
      // check permissions
      if (!await _requestPermissions()) {
        Fluttertoast.showToast(
            msg: "Storage permission denied",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        return;
      }

      // get video url
      var video = await _yt.videos.get(videoUrl);
      // get metadata
      var manifest = await _yt.videos.streamsClient.getManifest(video.id);
      // get stream info if mp3 or mp4
      var streamInfo = isMP3
          ? manifest.audioOnly.withHighestBitrate()
          : manifest.muxed.withHighestBitrate();
      var stream = _yt.videos.streamsClient.get(streamInfo);

      var dir = await _getDownloadDirectory();
      var sanitizedTitle = sanitizeFilename(video.title);
      var extension = isMP3 ? 'mp3' : 'mp4';
      var file = File('${dir!.path}/$sanitizedTitle.$extension');

      var fileStream = file.openWrite();

      var total = streamInfo.size.totalBytes;
      var downloaded = 0;

      final notificationService = _ref.read(notificationServiceProvider);
      final notificationId = DateTime.now().millisecondsSinceEpoch % 10000;

      await notificationService.showProgressNotification(
        id: notificationId,
        title: 'Downloading ${isMP3 ? "MP3" : "MP4"}',
        body: 'Starting download...',
        progress: 0,
        maxProgress: 100,
      );

      await for (var data in stream) {
        fileStream.add(data);
        downloaded += data.length;
        var progress = downloaded / total;
        _ref.read(downloadProgressProvider.notifier).setProgress(progress);

        if (progress % 0.01 < 0.001) {
          // Update notification every 1%
          await notificationService.showProgressNotification(
            id: notificationId,
            title: 'Downloading ${isMP3 ? "MP3" : "MP4"}',
            body: 'Progress: ${(progress * 100).toStringAsFixed(0)}%',
            progress: (progress * 100).toInt(),
            maxProgress: 100,
          );
        }
      }

      await fileStream.flush();
      await fileStream.close();

      await _saveDownloadRecord(file.path);
      _ref.read(downloadProgressProvider.notifier).reset();

      // Update the notification to show completion
      await notificationService.showCompletionNotification(
        id: notificationId,
        title: 'Download Complete',
        body: '${isMP3 ? "MP3" : "MP4"} downloaded to ${file.path}',
      );

      // Cancel the progress notification
      await notificationService.cancelNotification(id: notificationId);

      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "${isMP3 ? "MP3" : "MP4"} downloaded to ${file.path}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      log('Download error: $e');
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "Error downloading file: ${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
      _ref.read(downloadProgressProvider.notifier).reset();
      rethrow; // This will allow the error to be caught in the showDownloadProgress method
    }
  }

  // get download directory method
  Future<Directory?> _getDownloadDirectory() async {
    Directory? directory;

    try {
      switch (Platform.operatingSystem) {
        case 'android':
          directory = await getExternalStorageDirectory();
          if (directory != null) {
            directory = Directory('/storage/emulated/0/Download/YTConverter');
          } else {
            directory = await getApplicationDocumentsDirectory();
            directory = Directory('${directory.path}/YTConverter');
          }
          break;
        case 'ios':
          directory = await getApplicationDocumentsDirectory();
          directory = Directory('${directory.path}/YTConverter');
          break;
        default:
          throw UnsupportedError('Unsupported platform');
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } catch (e) {
      log('Download directory error: $e');
      Fluttertoast.showToast(
        msg: "Error setting up download directory: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
    return directory;
  }
}
