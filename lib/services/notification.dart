// utils
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define provider
final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  // init local notifications plugin
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // init notification plugin method
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_notification');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});

    await createNotificationChannel();
  }

  // notification data
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'download_channel',
        'Download Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showProgress: true,
        onlyAlertOnce: true,
        enableVibration: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // create notification channel method
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'download_channel', // id
      'Download Notifications', // name
      description: 'Notifications for download progress', // description
      importance: Importance.max,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // notification progress method
  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Download Notifications',
          channelDescription: 'Notifications for download progress',
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress,
        ),
      ),
    );
  }

  // show completed notification method
  Future<void> showCompletionNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Download Notifications',
          channelDescription: 'Notifications for download completion',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Cancel notification method
  Future<void> cancelNotification({required int id}) async {
    await notificationsPlugin.cancel(id);
  }
}
