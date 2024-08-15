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
import 'dart:io';

final downloadProgressProvider =
    StateNotifierProvider.family<DownloadProgressNotifier, double?, String>(
        (ref, videoUrl) => DownloadProgressNotifier());

class DownloadProgressNotifier extends StateNotifier<double?> {
  DownloadProgressNotifier() : super(null);

  void setProgress(double progress) {
    state = progress;
  }

  void reset() {
    state = null;
  }
}

// Define provider
final downloadServiceProvider = Provider((ref) => DownloadService(ref));

class DownloadService {
  final Ref _ref;
  final YoutubeExplode _yt;

  DownloadService(this._ref) : _yt = YoutubeExplode();

  Future<bool> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _saveDownloadRecord(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? downloads = prefs.getStringList('downloads');
    downloads = downloads ?? [];
    downloads.add(filePath);
    await prefs.setStringList('downloads', downloads);
  }

  Future<List<String>> getDownloadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('downloads') ?? [];
  }

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

  Future<Directory> _getDownloadDirectory() async {
    var dir = await getExternalStorageDirectory();
    var downloadDir = Directory(path.join(dir!.path, 'downloads'));
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }
}
