// utils
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getDownloadRecords() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('downloads') ?? [];
}
