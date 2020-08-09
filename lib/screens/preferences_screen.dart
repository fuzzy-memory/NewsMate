import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart' as pack;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../widgets/app_drawer.dart';
import '../providers/appstate.dart';

class PreferencesScreen extends StatefulWidget {
  static const routeName = "/preferences";
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  pack.PackageInfo packInfo;
  @override
  void initState() {
    super.initState();
    pack.PackageInfo.fromPlatform().then((value) => packInfo = value);
  }

  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Preferences"),
        backgroundColor: red,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: <Widget>[
            buildItem(
              title: "Dark Theme",
              subtitle: "Switch between light and dark themes",
              leading: Icons.brightness_medium,
              trailing: Switch(
                value: Provider.of<AppNDStatus>(context, listen: false)
                    .getDarkStatus,
                onChanged: (_) {
                  Provider.of<AppNDStatus>(context, listen: false)
                      .changeTheme();
                  setState(() {});
                },
              ),
            ),
            buildItem(
                title: "Daily notifications",
                leading: Icons.notifications,
                trailing: Switch(
                  value: Provider.of<AppNDStatus>(context, listen: false)
                      .showNotifsStatus,
                  onChanged: (_) {
                    Provider.of<AppNDStatus>(context, listen: false)
                        .toggleNotifs();
                    // setState(() {});
                  },
                )),
            GestureDetector(
              onTap: () {
                _launchURL("mailto:tush.machavolu@gmail.com");
              },
              child: buildItem(
                title: "Report an issue",
                leading: Icons.bug_report,
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            GestureDetector(
              onTap: buildDevSheet,
              child: buildItem(
                title: "About",
                leading: Icons.info_outline,
                subtitle: "About the app and the developer",
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      {@required String title,
      String subtitle,
      @required IconData leading,
      Widget trailing}) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: subtitle == null ? null : Text(subtitle),
                leading: Icon(leading),
                trailing: trailing ?? null),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void buildDevSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (ctx) => SingleChildScrollView(
        child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Text("About", style: TextStyle(fontSize: 24)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "App version:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "v${packInfo.version}",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Developed by:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: ExactAssetImage(
                                "assets/photo.jpg",
                              ),
                              radius: MediaQuery.of(context).size.height * 0.08,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Tushar Machavolu",
                              style: TextStyle(
                                  fontFamily: "PlayfairDisplay",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1),
                            ),
                            Text(
                              "Connect with me on:",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.mail),
                                  onPressed: () async {
                                    await _launchURL(
                                        "mailto:tush.machavolu@gmail.com");
                                  },
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.github),
                                  onPressed: () async {
                                    await _launchURL(
                                        "https://www.github.com/fuzzy-memory");
                                  },
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.twitter),
                                  onPressed: () async {
                                    await _launchURL(
                                        "https://twitter.com/_fuzzymemory");
                                  },
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.medium),
                                  onPressed: () async {
                                    await _launchURL(
                                        "https://medium.com/@fuzzymemory");
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
