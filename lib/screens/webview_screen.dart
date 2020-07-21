import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'bookmark_screen.dart';
import '../helpers/article.dart';
import '../providers/bookmarks_provider.dart';

class WebviewScreen extends StatefulWidget {
  static const routeName = "/web-view=screen";

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController webView;
  final globalKey = GlobalKey<ScaffoldState>();
  double progress = 0;
  // bool isBookMarked = false;
  @override
  Widget build(BuildContext context) {
    final Article args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(189, 22, 40, 1),
        title: Text(args.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              try {
                Share.share(
                    "${args.url}\n\nPowered by NewsMate.\nGet it on the Google Play Store:\nhttps://play.google.com/store/apps/details?id=com.fuzzymemory.news",
                    subject: args.title);
              } catch (e) {
                print(e);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              try {
                Provider.of<BookmarksProvider>(context, listen: false)
                    .addBookmark(args);
                globalKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      "Bookmarks updated!",
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 5,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 700),
                    action: SnackBarAction(
                      label: "View bookmarks",
                      textColor: Colors.white,
                      onPressed: () {Navigator.of(context).popAndPushNamed(BookMarksScreen.routeName);},
                    ),
                  ),
                );
              } catch (e) {
                _showErrorDialog(e);
              }
            },
          )
        ],
      ),
      body: InAppWebView(
        initialUrl: args.url,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
          debuggingEnabled: true,
        )),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
      
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
