import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

import '../main.dart';

class FollowUp {
  final int id;
  final String title;
  final String body;
  final String payload;

  FollowUp({this.id, this.body, this.payload, this.title});
}

void requestIOSPermissions(
    notifs.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          notifs.IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

final rxSub.BehaviorSubject<FollowUp> didReceiveLocalNotificationSubject =
    rxSub.BehaviorSubject<FollowUp>();
final rxSub.BehaviorSubject<String> selectNotificationSubject =
    rxSub.BehaviorSubject<String>();

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin
        flutterLocalNotificationsPlugin) async {
  var initializationSettingsAndroid =
      notifs.AndroidInitializationSettings('icon');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject
            .add(FollowUp(id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = notifs.InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  print("Notifications initialised successfully");
}

Future<void> scheduleNotification({
  notifs.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  String id,
}) async {
  var androidPlatformChannelSpecifics = notifs.AndroidNotificationDetails(
    id,
    'Daily notifications',
    'Notification shown in the morning',
    icon: 'icon',
    enableLights: true,
    color: red,
    enableVibration: true,
    playSound: true,
    importance: notifs.Importance.High,
    priority: notifs.Priority.High,
  );
  var iOSPlatformChannelSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics = notifs.NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showDailyAtTime(
    0,
    'Good morning!',
    "Check the latest business news before your workday begins.",
    notifs.Time(7, 30, 0),
    platformChannelSpecifics,
  );
}

Future<void> showenabledNotification({
  notifs.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  String id,
}) async {
  var androidPlatformChannelSpecifics = notifs.AndroidNotificationDetails(
    id,
    'Notifications Enabled',
    'Notification shown when daily notifications are enabled',
    icon: 'icon',
    enableLights: true,
    color: red,
    enableVibration: true,
    playSound: true,
    importance: notifs.Importance.High,
    priority: notifs.Priority.High,
  );
  var iOSPlatformChannelSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics = notifs.NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(1, "Notifications enabled!",
      "NewsMate will show daily notifications", platformChannelSpecifics);
}
