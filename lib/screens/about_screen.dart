import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart' as pack;
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = "/about";
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   packInfo = await pack.PackageInfo.fromPlatform();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: red,
        title: Text("About"),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "App version:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "v${packageInfo.version}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Developed by:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          await _launchURL("mailto:tush.machavolu@gmail.com");
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
                          await _launchURL("https://twitter.com/_fuzzymemory");
                        },
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.medium),
                        onPressed: () async {
                          await _launchURL("https://medium.com/@fuzzymemory");
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                thickness: 5,
              ),
            ),
            Text(
              "Made with \u2764 in Manipal",
              style: TextStyle(fontSize: 15),
            )
          ],
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
