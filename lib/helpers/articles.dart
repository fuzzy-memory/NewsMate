import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class Article {
  final String author;
  final String title;
  final String url;
  final String content;
  final String desc;

  Article({this.author, this.content, this.title, this.url, this.desc});

  @override
  String toString() {
    return 'Title: $title\nDesc: $desc\nAuthor: $author\nURL: $url\nContent:\n$content';
  }
}

class NewsProvider extends ChangeNotifier {
  List<Article> _item = [];
  
  List<Article> get items {
    return [..._item];
  }

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
        _item.add(newart);
      }
      print("Fetch complete");
      // print(art);
      notifyListeners();
    }
    catch(e){
      throw e;
    }
  }
}
