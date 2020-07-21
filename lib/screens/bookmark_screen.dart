import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'webview_screen.dart';
import '../main.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/app_drawer.dart';

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
                    "News bookmarks you bookmark will be added here.\nSwipe on a bookmarked article to delete it",
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
                    onTap: ()=>buildPreviewSheet(index),
                    onLongPress: (){
                      Share.share("${art.bookmarks[index].url}\n\nPowered by NewsMate.\nGet it on the Google Play Store:\nhttps://play.google.com/store/apps/details?id=com.fuzzymemory.news",
                    subject: art.bookmarks[index].title);
                    },
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(art.bookmarks[index].url),
                      onDismissed: (_) {
                        setState(() {
                          art.removeBookmark(art.bookmarks[index].url);
                        });
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
                              "Do you want to remove the selected bookmark?",
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("YES"),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                              FlatButton(
                                child: Text("NO"),
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

  void buildPreviewSheet(int index) {
    final art = Provider.of<BookmarksProvider>(context, listen: false);
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
                    color: red.withOpacity(0.4),
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
                            art.bookmarks[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "PlayfairDisplay"),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(art.bookmarks[index].pub.isEmpty
                                ? "Date of publishing unknown"
                                : "Published on: ${art.bookmarks[index].pub} IST"),
                          ),
                          art.bookmarks[index].imgURL == "Unknown"
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: art.bookmarks[index].imgURL.contains("Unknown") 
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
                                            art.bookmarks[index].imgURL,
                                            alignment: Alignment.center,
                                            errorBuilder: (_,__,___)=>Row(
                                        children: <Widget>[
                                          Expanded(child: Image.asset("assets/404.png", ), flex: 7,),
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
                              art.bookmarks[index].desc,
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
                                  Text("Continue reading"),
                                  Icon(Icons.chevron_right)
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                  WebviewScreen.routeName,
                                  arguments: art.bookmarks[index],
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
