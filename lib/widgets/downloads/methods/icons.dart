// utils
import 'package:flutter/material.dart';

Icon getFileIcon(String filePath) {
  if (filePath.endsWith('.mp3')) {
    return const Icon(Icons.music_note, color: Colors.blue);
  } else if (filePath.endsWith('.mp4')) {
    return const Icon(Icons.movie, color: Colors.red);
  } else {
    return const Icon(Icons.insert_drive_file, color: Colors.grey);
  }
}
