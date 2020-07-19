import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart' as pack;
import 'package:url_launcher/url_launcher.dart';

import '../screens/about_screen.dart';
import '../screens/bookmark_screen.dart';
import '../screens/main_screen.dart';

pack.PackageInfo packageInfo;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed(MainScreen.routeName);
            },
            child: DrawerHeader(
              child: Row(
                children: <Widget>[
                  Image.asset("assets/bugle.png"),
                  Text(
                    "NewsMate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "PlayfairDisplay",
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed(MainScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text("Bookmarks"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed(BookMarksScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.warning),
            title: Text("Report an issue"),
            onTap: () async {
              Navigator.of(context).pop();
              _launchURL("mailto:tush.machavolu@gmail.com");
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About"),
            onTap: () async {
              packageInfo = await pack.PackageInfo.fromPlatform();
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed(AboutScreen.routeName);
            },
          ),
        ],
      ),
      elevation: 10,
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }
}
