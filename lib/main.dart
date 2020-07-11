import 'package:flutter/material.dart';
import 'package:news/screens/webview_screen.dart';
import 'package:provider/provider.dart';

import './helpers/articles.dart';
import './screens/main_screen.dart';
import './screens/splash_screen.dart';

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
          debugShowCheckedModeBanner: false,
          title: 'News',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
          routes: {
            MainScreen.routeName: (ctx) => MainScreen(),
            WebviewScreen.routeName: (ctx) => WebviewScreen(),
            SplashScreen.routeName: (ctx) => SplashScreen(),
          },
        ),
      ),
    );
  }
}
