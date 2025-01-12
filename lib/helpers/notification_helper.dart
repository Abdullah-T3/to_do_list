import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(initializationSettings);
    await requestNotificationPermission();
    await requestExactAlarmPermission();
  }
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    RepeatInterval? repeatInterval,
  }) async {
    try {
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        throw ArgumentError('Scheduled time must be in the future');
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel_id',
            'Task Notifications',
            channelDescription: 'Reminder for tasks',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: repeatInterval != null ? DateTimeComponents.time : null,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notification scheduled for $scheduledTime');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }


  static Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
      if (status.isPermanentlyDenied) {
        print("Notification permission permanently denied. Redirecting to settings...");
        openAppSettings();
      }
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      print("Requesting exact alarm permission...");
      openAppSettings();
    } else {
      print("Exact alarm permission already granted.");
    }
  }

  /// Show an immediate notification
  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? channelId,
    String? channelName,
    String? channelDescription,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId ?? 'default_channel_id',
        channelName ?? 'Default Notifications',
        channelDescription: channelDescription ?? 'Default channel description',
        importance: importance,
        priority: priority,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails),
      );

      print("Immediate notification shown: $title");
    } catch (e) {
      print("Error showing immediate notification: $e");
    }
  }
}
