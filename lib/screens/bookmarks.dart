import 'package:flutter/material.dart';
import 'package:news/widgets/app_drawer.dart';

import "../main.dart";

class BookMarksScreen extends StatefulWidget {
  static const routeName = "/bookmarks";
  @override
  _BookMarksScreenState createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Bookmarks"),
        backgroundColor: red,
      ),
    );
  }
}
