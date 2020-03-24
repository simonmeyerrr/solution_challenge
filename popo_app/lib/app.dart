import 'package:flutter/material.dart';

import 'home_page.dart';

class DrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'DrawApp',
            home: HomePage(title: "DrawApp"),
          );
  }
}