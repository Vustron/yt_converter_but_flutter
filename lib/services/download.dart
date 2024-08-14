// utils
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Define provider
final downloadServiceProvider = Provider((ref) => DownloadService());

class DownloadService {
  // init yt explode
  final YoutubeExplode _yt;

  // init service
  DownloadService() : _yt = YoutubeExplode();

  // download mp3
  Future<void> downloadMp3(String videoId, BuildContext context) async {
    try {
      var video = await _yt.videos.get(videoId);
      var manifest = await _yt.videos.streamsClient.getManifest(videoId);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
      var audioStream = _yt.videos.streamsClient.get(audioStreamInfo);

      var dir = await getExternalStorageDirectory();
      var file = File('${dir!.path}/${video.title}.mp3');
      var fileStream = file.openWrite();

      await audioStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      Fluttertoast.showToast(
          msg: "MP3 downloaded to ${file.path}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to download MP3",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  // download mp4
  Future<void> downloadMp4(String videoId, BuildContext context) async {
    try {
      var video = await _yt.videos.get(videoId);
      var manifest = await _yt.videos.streamsClient.getManifest(videoId);
      var videoStreamInfo = manifest.muxed.withHighestBitrate();
      var videoStream = _yt.videos.streamsClient.get(videoStreamInfo);

      var dir = await getExternalStorageDirectory();
      var file = File('${dir!.path}/${video.title}.mp4');
      var fileStream = file.openWrite();

      await videoStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      Fluttertoast.showToast(
          msg: "MP4 downloaded to ${file.path}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to download MP4",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
