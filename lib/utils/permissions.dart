// utils
import 'package:permission_handler/permission_handler.dart';

// check and request permissions handlers
Future<bool> checkAndRequestPermissions() async {
  if (await Permission.storage.isGranted) {
    return true;
  }
  var status = await Permission.storage.request();
  if (status.isGranted) {
    return true;
  }
  if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
  return false;
}
