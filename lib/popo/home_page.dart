import 'package:flutter/material.dart';

import 'package:solution_challenge/popo/draw_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  //Set default painter values
  List<Offset> points = <Offset>[];
  Color color = Colors.black;
  StrokeCap strokeCap = StrokeCap.round;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawPage());
  }
}
