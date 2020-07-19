import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/app_drawer.dart';
import 'webview_screen.dart';

class BookMarksScreen extends StatefulWidget {
  static const routeName = "/bookmarks";
  @override
  _BookMarksScreenState createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Provider.of<BookmarksProvider>(context, listen: false)
        .fetchBookmarks()
        .then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    final art = Provider.of<BookmarksProvider>(context, listen: false);
    return Scaffold(
      key: globalKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Bookmarks"),
        backgroundColor: red,
      ),
      body: art.bookmarks.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    "assets/paper.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    "News items you bookmark will be added here.\nSwipe on a bookmarked article to delete it",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        WebviewScreen.routeName,
                        arguments: art.bookmarks[index],
                      );
                    },
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(art.bookmarks[index].url),
                      onDismissed: (_) {
                        art.removeBookmark(art.bookmarks[index].url);
                        globalKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Bookmark has been removed!",
                              style: TextStyle(color: Colors.white),
                            ),
                            elevation: 5,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            duration: Duration(milliseconds: 700),
                            action: SnackBarAction(
                              label: "OK",
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      background: Card(
                        color: red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Icon(
                              Icons.delete,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              "Are you sure?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Do you want to remove the selected item?",
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(
                              art.bookmarks[index].title,
                              style: TextStyle(fontSize: 18),
                            ),
                            // subtitle:Text(art[index].) ,
                            trailing: art.bookmarks[index].imgURL == "Unknown"
                                ? null
                                : Image.network(art.bookmarks[index].imgURL),
                            subtitle: Text(art.bookmarks[index].pub.isEmpty
                                ? "${art.bookmarks[index].src}\nDate of publishing unknown"
                                : "${art.bookmarks[index].src}\nPublished on: ${art.bookmarks[index].pub} IST"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: art.bookmarks.length,
              ),
            ),
    );
  }
}
