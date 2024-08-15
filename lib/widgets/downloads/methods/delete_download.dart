// utils
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

// type
typedef UpdateDownloadsCallback = Future<void> Function();

Future<void> deleteDownload(
    String filePath, UpdateDownloadsCallback updateDownloads) async {
  try {
    // init shared preference
    final prefs = await SharedPreferences.getInstance();

    // init list of downloads
    List<String>? downloads = prefs.getStringList('downloads');

    // null guard
    if (downloads != null) {
      downloads.remove(filePath);
      await prefs.setStringList('downloads', downloads);
    }

    // init file path
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    Fluttertoast.showToast(
        msg: "File deleted successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);

    await updateDownloads();
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Could not delete the file: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }
}
