import 'dart:ffi';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_improvement/Database.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:intl/intl.dart';

class NotificationContent {
  String notificationTitle;
  String notificationBody;
  DateTime notificationDate;

  NotificationContent(
      {required this.notificationTitle,
      required this.notificationBody,
      required this.notificationDate});
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings();

    // #2
    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await flutterLocalNotificationsPlugin.initialize(initSettings).then((_) {
      print("Notification success");
    }).catchError((Object error) {
      print('Error: $error');
    });
  }

  void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static List<NotificationContent> convertTasksIntoNotifications(
      List<PlayerTask> tasks) {
    List<NotificationContent> notifications = [];

    List<PlayerTask> notCompletedTasks =
        tasks.where((element) => !element.complete_Status).toList();

    for (PlayerTask task in tasks) {
      DateFormat format = DateFormat('y-M-d hh:mm:ss a');
      final notificationDate = format.parse(task.DelayTime);

      if (DateTime.now().millisecondsSinceEpoch <
          notificationDate.millisecondsSinceEpoch) {
        String notificationTitle =
            'It\'s time to ${task.task_title.toLowerCase()}!';
        String notificationBody = 'You can complete a task';

        // DateTime.parse(task.DelayTime);

        NotificationContent content = NotificationContent(
          notificationDate: notificationDate,
          notificationBody: notificationBody,
          notificationTitle: notificationTitle,
        );
        notifications.add(content);
      }
    }

    return notifications;
  }

  Future<void> setNotifications(List<NotificationContent> notifications) async {
    cancelAllNotifications();

    var i = 0;
    for (NotificationContent content in notifications) {
      tzData.initializeTimeZones();
      final scheduleTime =
          tz.TZDateTime.from(content.notificationDate, tz.local);

      final androidDetail =
          AndroidNotificationDetails('task-end', 'task-end', 'task-end');

      final iosDetail = IOSNotificationDetails();

      final noticeDetail = NotificationDetails(
        iOS: iosDetail,
        android: androidDetail,
      );

      final id = i;
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        content.notificationTitle,
        content.notificationBody,
        scheduleTime,
        noticeDetail,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      i += 1;
    }
  }

  Future<void> addNotification(String notificationTitle,
      String notificationBody, dynamic endTime, String channel) async {
    // #1
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    final androidDetail = AndroidNotificationDetails(channel, channel, channel);

    final iosDetail = IOSNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    final id = 0;

    print(scheduleTime);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      notificationTitle,
      notificationBody,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
