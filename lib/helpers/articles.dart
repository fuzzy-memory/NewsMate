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
  List<String> _sources = [];

  List<Article> get items {
    return [..._item];
  }

  List<String> get src {
    return [..._sources];
  }

  Future<void> getNews() async {
    try {
      _item = [];
      final url =
          "http://newsapi.org/v2/top-headlines?country=in&pageSize=100&category=business&apiKey=$APIKey";
      final res = await http.get(url);
      final resData = json.decode(res.body);
      for (var obj in resData['articles']) {
        final newart = Article(
          author: obj['author'] ?? "Unknown",
          content: obj['content'] ?? "Unknown",
          title: obj['title'] ?? "Unknown",
          url: obj['url'] ?? "Unknown",
          desc: obj['description'] ?? "Unknown",
        );
        _item.add(newart);
      }
      print("Fetch complete");
      // print(art);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getSources() async {
    try {
      _sources = [];
      final url = "https://newsapi.org/v2/sources?country=in&apiKey=$APIKey";
      final res = await http.get(url);
      final resData = json.decode(res.body);
      for (var obj in resData['sources']) {
        _sources.add(obj['name'] ?? "Unknown");
      }
      print("Fetch complete");
      // print(_sources);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
