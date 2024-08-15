// utils
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_converter/utils/sanitize_filename.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

// download progress provider
final downloadProgressProvider =
    StateNotifierProvider.family<DownloadProgressNotifier, double?, String>(
        (ref, videoUrl) => DownloadProgressNotifier());

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
    if (!await _requestPermissions()) {
      Fluttertoast.showToast(
          msg: "Storage permission denied",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    var video = await _yt.videos.get(videoUrl);
    var manifest = await _yt.videos.streamsClient.getManifest(video.id);
    var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    var audioStream = _yt.videos.streamsClient.get(audioStreamInfo);

    var dir = await _getDownloadDirectory();
    var sanitizedTitle = sanitizeFilename(video.title);
    var file = File(path.join(dir.path, '$sanitizedTitle.mp3'));
    var fileStream = file.openWrite();

    var total = audioStreamInfo.size.totalBytes;
    var downloaded = 0;

    await for (var data in audioStream) {
      fileStream.add(data);
      downloaded += data.length;
      _ref
          .read(downloadProgressProvider(videoUrl).notifier)
          .setProgress(downloaded / total);
    }

    await fileStream.flush();
    await fileStream.close();

    await _saveDownloadRecord(file.path);
    _ref.read(downloadProgressProvider(videoUrl).notifier).reset();

    if (context.mounted) {
      Fluttertoast.showToast(
          msg: "MP3 downloaded to ${file.path}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  // download mp4 method
  Future<void> downloadMp4(String videoUrl, BuildContext context) async {
    if (!await _requestPermissions()) {
      Fluttertoast.showToast(
          msg: "Storage permission denied",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    var video = await _yt.videos.get(videoUrl);

    if (video.isLive) {
      Fluttertoast.showToast(
          msg:
              "Cannot download live streams. Please wait until the stream ends and try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    var manifest = await _yt.videos.streamsClient.getManifest(video.id);
    var videoStreamInfo = manifest.muxed.withHighestBitrate();
    var videoStream = _yt.videos.streamsClient.get(videoStreamInfo);

    var dir = await _getDownloadDirectory();
    var sanitizedTitle = sanitizeFilename(video.title);
    var file = File(path.join(dir.path, '$sanitizedTitle.mp4'));
    var fileStream = file.openWrite();

    var total = videoStreamInfo.size.totalBytes;
    var downloaded = 0;

    await for (var data in videoStream) {
      fileStream.add(data);
      downloaded += data.length;
      _ref
          .read(downloadProgressProvider(videoUrl).notifier)
          .setProgress(downloaded / total);
    }

    await fileStream.flush();
    await fileStream.close();

    await _saveDownloadRecord(file.path);
    _ref.read(downloadProgressProvider(videoUrl).notifier).reset();

    if (context.mounted) {
      Fluttertoast.showToast(
          msg: "MP4 downloaded to ${file.path}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  // download directory
  Future<Directory> _getDownloadDirectory() async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        // For Android, use the Downloads directory
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        // For iOS, we'll use the Documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      // Create a subdirectory for our app if it doesn't exist
      var appDir = Directory('${directory!.path}/YTConverter');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      return appDir;
    } catch (e) {
      log('Failed to get download directory: $e');
      // Fallback to the app's directory if we can't access the Downloads folder
      return await getApplicationDocumentsDirectory();
    }
  }
}
