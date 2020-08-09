import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import "../main.dart";
import '../helpers/notifications_helper.dart';

class AppNDStatus extends ChangeNotifier {
  bool isDark =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  bool showNotifs = true;

  bool get getDarkStatus {
    return isDark;
  }

  bool get showNotifsStatus {
    return showNotifs;
  }

  void toggleNotifs() async {
    showNotifs = !showNotifs;
    if (showNotifsStatus) {
      await showenabledNotification(
          id: "1", flutterLocalNotificationsPlugin: notifsPlugin);
      await scheduleNotification(
        id: "0",
        flutterLocalNotificationsPlugin: notifsPlugin,
      );
      List<PendingNotificationRequest> list=await notifsPlugin.pendingNotificationRequests();
      print(list[0].title);
    } else {
      await notifsPlugin.cancelAll();
      print(await notifsPlugin.pendingNotificationRequests());
    }
    notifyListeners();
  }

  void changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
