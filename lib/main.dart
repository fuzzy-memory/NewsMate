import 'package:flutter/material.dart';
import 'package:news/webview_screen.dart';
import 'package:provider/provider.dart';

import './helpers/articles.dart';
import './helpers/webview_arguments.dart';


// List<Article> art = new List();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: NewsProvider()),
      ],
      child: Consumer<NewsProvider>(
        builder: (ctx, newsProvider, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Start(),
          routes: {
            WebviewScreen.routeName: (ctx) => WebviewScreen(),
          },
        ),
      ),
    );
  }
}

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
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
      _showErrorDialog("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("News"),
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
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // globalKey.currentState.showSnackBar(
            //   SnackBar(
            //     action: SnackBarAction(
            //       label: "OK",
            //       textColor: Colors.white,
            //       onPressed: (){},
            //     ),
            //     content: Text(
            //       "Opening in webview",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     backgroundColor: Colors.green,
            //     elevation: 5,
            //     behavior: SnackBarBehavior.floating,
            //   ),
            // );
            Navigator.of(context).pushNamed(
              WebviewScreen.routeName,
              arguments: WebViewArguments(url: "${art[index].url}", title: "${art[index].title}"),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                art[index].title,
                style: TextStyle(fontSize: 24),
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
