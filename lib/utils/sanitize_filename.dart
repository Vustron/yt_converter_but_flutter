String sanitizeFilename(String filename) {
  return filename.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
}
