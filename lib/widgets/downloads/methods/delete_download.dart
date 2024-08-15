import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef UpdateDownloadsCallback = Future<void> Function();

Future<void> deleteDownload(
    String filePath, UpdateDownloadsCallback updateDownloads) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<String>? downloads = prefs.getStringList('downloads');
    if (downloads != null) {
      downloads.remove(filePath);
      await prefs.setStringList('downloads', downloads);
    }

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
