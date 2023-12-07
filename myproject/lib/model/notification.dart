import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotification {
  LocalNotification._();

  static FlutterLocalNotificationsPlugin LocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    tz.initializeTimeZones();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await LocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() {
    LocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleNotification(DateTime scheduledTime) async {
    int notificationId = 0; // You can use a unique id for each notification

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    Duration timeDifference = scheduledTime.difference(DateTime.now());
    int minutesDifference = timeDifference.inMinutes;

    String notificationMessage =
        '목표 시간까지 ${minutesDifference ~/ 60}시간 ${minutesDifference % 60}분 남았습니다! 힘내세요 :)';

    await LocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '목표 시간 알림',
      notificationMessage,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}