import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:firebase_messaging/firebase_messaging.dart' as fire;

import 'helpers/notifications_helper.dart';
import 'providers/appstate.dart';
import 'providers/news_provider.dart';
import 'providers/bookmarks_provider.dart';
import 'screens/preferences_screen.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/webview_screen.dart';
import 'screens/bookmark_screen.dart';

Color red = Color.fromRGBO(189, 22, 40, 1);
notifs.NotificationAppLaunchDetails notifLaunch;
final notifs.FlutterLocalNotificationsPlugin notifsPlugin =
    notifs.FlutterLocalNotificationsPlugin();
final fire.FirebaseMessaging firebaseMessaging = fire.FirebaseMessaging();
void fcmSetup() {
  firebaseMessaging.subscribeToTopic("all");
  firebaseMessaging.configure(
    onLaunch: (Map<String, dynamic> message) {
      print('onLaunch called');
      print(message);
    },
    onResume: (Map<String, dynamic> message) {
      print('onResume called');
      print(message);
    },
    onMessage: (Map<String, dynamic> message) {
      print('onMessage called');
      print(message);
    },
  );
  firebaseMessaging.getToken().then((token) {
    print(token); // Print the Token in Console
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  requestIOSPermissions(notifsPlugin);
  fcmSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppNDStatus()),
        ChangeNotifierProvider.value(value: NewsProvider()),
        ChangeNotifierProvider.value(value: BookmarksProvider()),
      ],
      child: Consumer<AppNDStatus>(
        builder: (ctx, appstate, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NewsMate',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: "RobotoSlab",
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: "RobotoSlab",
            brightness: Brightness.dark,
          ),
          themeMode: appstate.getDarkStatus ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
          routes: {
            MainScreen.routeName: (ctx) => MainScreen(),
            WebviewScreen.routeName: (ctx) => WebviewScreen(),
            SplashScreen.routeName: (ctx) => SplashScreen(),
            BookMarksScreen.routeName: (ctx) => BookMarksScreen(),
            PreferencesScreen.routeName: (ctx) => PreferencesScreen(),
          },
        ),
      ),
    );
  }
}
