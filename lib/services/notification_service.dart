// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:get/get.dart';
// import '../data/models/task_model.dart';
//
// class NotificationService extends GetxService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<NotificationService> init() async {
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _notificationsPlugin.initialize(initializationSettings);
//     return this;
//   }
//
//   Future<void> scheduleNotification(Task task) async {
//     if (task.dueDate == null || !task.reminderEnabled) return;
//
//     final scheduledDate = tz.TZDateTime.from(task.dueDate!, tz.local);
//
//     // If the due date is in the past, don't schedule
//     if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;
//
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'task_reminders',
//       'Task Reminders',
//       channelDescription: 'Notifications for task reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.zonedSchedule(
//       task.id.hashCode,
//       'Task Reminder',
//       task.title,
//       scheduledDate,
//       platformDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   Future<void> cancelNotification(Task task) async {
//     await _notificationsPlugin.cancel(task.id.hashCode);
//   }
// }
