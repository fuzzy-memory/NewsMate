import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/articles.dart';
import '../helpers/webview_arguments.dart';
import 'webview_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    try {
      super.didChangeDependencies();
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<NewsProvider>(context, listen: false).getSources();
        Provider.of<NewsProvider>(context, listen: false).getNews().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      _isInit = false;
    } catch (e) {
      _showErrorDialog(e);
    }
  }

  Future<void> _refresher(BuildContext context) async {
    try {
      print("Fetching news");
      setState(() {
        _isLoading = true;
      });
      await Provider.of<NewsProvider>(context, listen: false).getSources();
      Provider.of<NewsProvider>(context, listen: false).getNews().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      _showErrorDialog(
          "Something went wrong. Check your internet connection and try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(189, 22, 40, 1),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Image.asset("assets/bugle.png", height: 60),
              onTap: () => _refresher(context),
            ),
            Text("Latest News"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refresher(context),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Container(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Fetching news. Please wait"),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refresher(context),
              child: Center(child: buildList(context)),
            ),
    );
  }

  Widget buildList(BuildContext context) {
    final art = Provider.of<NewsProvider>(context, listen: false).items;
    return art.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  "assets/404.png",
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Text("Nothing to see here", style: TextStyle(fontSize: 20)),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    WebviewScreen.routeName,
                    arguments: WebViewArguments(
                        url: "${art[index].url}", title: "${art[index].title}"),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                        art[index].title,
                        style: TextStyle(fontSize: 18),
                      ),
                      // subtitle:Text(art[index].) ,
                      trailing: art[index].imgURL=="Unknown"
                          ? null
                          : Image.network(art[index].imgURL),
                      subtitle: Text(art[index].pub.isEmpty
                          ? "${art[index].src}\nDate of publishing unknown"
                          : "${art[index].src}\nPublished on: ${art[index].pub} IST"),
                    ),
                  ),
                ),
              );
            },
            itemCount: art.length,
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
