import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../api.dart';

class Article {
  final String author;
  final String title;
  final String url;
  final String content;
  final String desc;
  final String imgURL;
  final String src;
  final String pub;

  Article(
      {this.pub,
      this.src,
      this.author,
      this.content,
      this.title,
      this.url,
      this.desc,
      this.imgURL});

  @override
  String toString() {
    return 'Source: $imgURL\nTitle: $title\nDesc: $desc\nAuthor: $author\nURL: $url\nContent:\n$content';
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
        var obj2 = obj['source'];
        DateTime date = DateTime.parse(obj['publishedAt']);
        date.add(Duration(hours: 5, minutes: 30));
        String data = DateFormat.yMEd().add_Hms().format(date);
        final newart = Article(
          author: obj['author'] ?? "Unknown",
          content: obj['content'] ?? "Unknown",
          title: obj['title'] ?? "Unknown",
          url: obj['url'] ?? "Unknown",
          desc: obj['description'] ?? "Unknown",
          imgURL: obj['urlToImage'] ?? "Unknown",
          src: obj2['name'] ?? "Source unknown",
          pub: data ?? "",
        );
        _item.add(newart);
      }
      print("Fetch complete");
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
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
