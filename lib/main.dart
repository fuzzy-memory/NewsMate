import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import './helpers/articles.dart';

const APIKey = "7b2fce715b614d6c879b1a11e86c7d0d";
List<Article> art = new List();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Start(),
    );
  }
}

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  Future<void> getNews() async {
    try{
      final url =
          "http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$APIKey";
      final res = await http.get(url);
      final resData = json.decode(res.body);
      for (var obj in resData['articles']) {
        final newart = Article(
          author: obj['author'] ?? "Unknown",
          content: obj['content'] ?? "Unknown",
          title: obj['title'] ?? "Unknown",
          url: obj['url'] ?? "Unknown",
          desc: obj['description']??"Unknown",
        );
        art.add(newart);
      }
      print("News fetch complete");
      // print(art);
    }
    catch(e){
      print(e);
    }
  }
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    await getNews();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Hit it"),
          onPressed: () async {
            getNews();
          },
        ),
      ),
    );
  }
}
