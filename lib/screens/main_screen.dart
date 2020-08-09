import 'package:flutter/material.dart';
import 'package:news/helpers/notifications_helper.dart';
import 'package:news/providers/appstate.dart';
import 'package:provider/provider.dart';

import 'bookmark_screen.dart';
import 'webview_screen.dart';
import '../main.dart';
import '../providers/bookmarks_provider.dart';
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
  bool isDark;
  String post404;
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
    isDark = Provider.of<AppNDStatus>(context, listen: false).getDarkStatus;
    post404=isDark?"dark":"light";
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Fetching news. Please wait"),
                    CircularProgressIndicator(),
                  ],
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
                  "assets/404-$post404.png",
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
                onTap: () => buildPreviewSheet(index),
                onLongPress: () {
                  Provider.of<BookmarksProvider>(context, listen: false)
                      .addBookmark(art[index]);
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
                        onPressed: () {
                          Navigator.of(context)
                              .popAndPushNamed(BookMarksScreen.routeName);
                        },
                      ),
                    ),
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
                      isThreeLine: true,
                      trailing: art[index].imgURL == "Unknown"
                          ? null
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(art[index].imgURL),
                            ),
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

  void buildPreviewSheet(int index) {
    final art = Provider.of<NewsProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      elevation: 7,
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
            child: Column(
              children: <Widget>[
                Container(
                  width: 50,
                  child: Divider(
                    thickness: 5,
                    color: isDark ? red.withOpacity(0.4) : red,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            art.items[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "PlayfairDisplay"),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(art.items[index].pub.isEmpty
                                ? "Date of publishing unknown"
                                : "Published on: ${art.items[index].pub} IST"),
                          ),
                          art.items[index].imgURL == "Unknown"
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: art.items[index].imgURL
                                            .contains("Unknown")
                                        ? Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Image.asset(
                                                  "assets/404.png",
                                                ),
                                                flex: 7,
                                              ),
                                              Text(
                                                  "Something went wrong loading the image"),
                                            ],
                                          )
                                        : Image.network(
                                            art.items[index].imgURL,
                                            alignment: Alignment.center,
                                            errorBuilder: (_, __, ___) => Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Image.asset(
                                                    "assets/404.png",
                                                  ),
                                                  flex: 7,
                                                ),
                                                Text(
                                                    "Something went wrong loading the image"),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16,
                            ),
                            child: Text(
                              art.items[index].desc,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              elevation: 3,
                              color: red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Continue reading",
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: isDark ? Colors.black : Colors.white,
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                  WebviewScreen.routeName,
                                  arguments: art.items[index],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
