import 'dart:async';

import 'package:flutter/material.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), ()=>Navigator.pushReplacementNamed(context, MainScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset('assets/bugle.png'),
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Text(
                  "NEWSMATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoSlab",
                    fontWeight: FontWeight.w700,
                    fontSize: 27,
                    letterSpacing: 10,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Business news. Simplified.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoSlab",
                    // fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w200,
                    fontSize: 18,
                    letterSpacing: 2,
                    // wordSpacing: 2
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
