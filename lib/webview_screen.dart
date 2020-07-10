import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import './main.dart';
import './helpers/webview_arguments.dart';

class WebviewScreen extends StatefulWidget {
  static const routeName = "/web-view=screen";

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController webView;
  // String url = ;
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    final WebViewArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
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
        // onLoadStart: (InAppWebViewController controller, String url) {
        //   setState(() {
        //     args.url = url;
        //   });
        // },
        // onLoadStop:
        //     (InAppWebViewController controller, String url) async {
        //   setState(() {
        //     args.url = url;
        //   });
        // },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
    );
  }
}
