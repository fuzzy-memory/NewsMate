import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/articles.dart';

class SourcesList extends StatefulWidget {
  @override
  _SourcesListState createState() => _SourcesListState();
}

class _SourcesListState extends State<SourcesList> {
  @override
  Widget build(BuildContext context) {
    final srcProvider = Provider.of<NewsProvider>(context);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            "Sources",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: srcProvider.src.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      srcProvider.src[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
