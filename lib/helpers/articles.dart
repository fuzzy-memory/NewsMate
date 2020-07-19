import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news/helpers/db_helper.dart';
import 'package:news/main.dart';
import 'package:provider/provider.dart';

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
  List<Article> _bookm = [];
  List<Article> _item = [];

  List<Article> get items {
    return [..._item];
  }

  List<Article> get bookmarks {
    return [..._bookm];
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
      print("News fetched");
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addBookmark(Article arg) async {
    try {
      if (_bookm.contains(arg)) return;
      _bookm.add(arg);
      DBHelper.insert(
        DBHelper.table,
        {
          DBHelper.url: arg.url,
          DBHelper.title: arg.title,
          DBHelper.imgurl: arg.imgURL,
          DBHelper.src: arg.src,
          DBHelper.pub: arg.pub,
        },
      );
      notifyListeners();
      print("Bookmark added successfully");
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchBookmarks() async {
    try {
      final dataList = await DBHelper.getData(DBHelper.table);
      _bookm = dataList
          .map((item) => Article(
                url: item[DBHelper.url],
                title: item[DBHelper.title],
                imgURL: item[DBHelper.imgurl],
                src: item[DBHelper.src],
                pub: item[DBHelper.pub],
              ))
          .toList();
      notifyListeners();
      print("Bookmarks fetched");
    } catch (e) {
      print(e);
    }
  }

  void removeBookmark(String url) {
    try {
      _bookm.removeWhere((element) => element.url == url);
      DBHelper.delID(url);
      notifyListeners();
      print("Bookmark removed successfully");
    } catch (e) {
      throw e;
    }
  }
}
