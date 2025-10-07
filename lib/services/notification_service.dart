import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  /// แจ้งเตือนครั้งเดียว + Pre-alerts (30, 15 นาที)
  static Future<void> scheduleDailyOnceWithPreAlerts(Map<String, dynamic> task) async {
    final id = Random().nextInt(999999);
    final hour = task["hour"] as int;
    final minute = task["minute"] as int;
    final title = task["title"] as String;

    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    final at = tz.TZDateTime.from(scheduled, tz.local);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel',
        'Daily Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    // ตรงเวลา
    await _plugin.zonedSchedule(
      id,
      'Origin',
      title,
      at,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );

    // ก่อน 30 นาที
    await _plugin.zonedSchedule(
      id + 1,
      'Origin (อีก 30 นาที)',
      title,
      at.subtract(const Duration(minutes: 30)),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );

    // ก่อน 15 นาที
    await _plugin.zonedSchedule(
      id + 2,
      'Origin (อีก 15 นาที)',
      title,
      at.subtract(const Duration(minutes: 15)),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

  /// แจ้งเตือนซ้ำทุกวันเวลาเดิม
  static Future<void> scheduleDailyRepeating(Map<String, dynamic> task) async {
    final hour = task["hour"] as int;
    final minute = task["minute"] as int;
    final title = task["title"] as String;

    final nowTz = tz.TZDateTime.now(tz.local);
    var first = tz.TZDateTime(tz.local, nowTz.year, nowTz.month, nowTz.day, hour, minute);
    if (first.isBefore(nowTz)) first = first.add(const Duration(days: 1));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'repeat_channel',
        'Repeating Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      Random().nextInt(999999),
      'Origin',
      title,
      first,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// แจ้งเตือนทุก X นาที สำหรับ 24 ชั่วโมง
  static Future<void> scheduleIntervalForNext24h(Map<String, dynamic> task) async {
    final minutes = (task["minutes"] as int).clamp(1, 1440);
    final title = task["title"] as String;

    final start = tz.TZDateTime.now(tz.local);
    final end = start.add(const Duration(hours: 24));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'interval_channel',
        'Interval Notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
    );

    int i = 0;
    for (var t = start; t.isBefore(end); t = t.add(Duration(minutes: minutes))) {
      await _plugin.zonedSchedule(
        Random().nextInt(999999),
        'Origin',
        title,
        t,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle    
      );
      i++;
      if (i > 500) break;
    }
  }
}
