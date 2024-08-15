// utils
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

Future<void> checkAndRequestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  if (statuses[Permission.storage] != PermissionStatus.granted) {
    log('Storage permission is not granted');
  }
}
