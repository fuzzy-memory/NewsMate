import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'webview_screen.dart';
import '../main.dart';
import '../providers/news_provider.dart';
import '../widgets/app_drawer.dart';

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
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: red,
        title: GestureDetector(
          onTap: () => _refresher(context),
          child: Text("Latest News"),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: buildList(context)),
              ),
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
                Text(
                  "Something went wrong",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    WebviewScreen.routeName,
                    arguments: art[index],
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
                      trailing: art[index].imgURL == "Unknown"
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
