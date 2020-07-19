import 'package:flutter/foundation.dart';

import '../helpers/article.dart';
import '../helpers/db_helper.dart';

class BookmarksProvider extends ChangeNotifier {
  List<Article> _bookm = [];
  List<Article> get bookmarks {
    return [..._bookm];
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
