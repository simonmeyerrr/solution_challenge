import 'package:flutter/material.dart';
import 'package:solution_challenge/services/authentication.dart';
import 'package:solution_challenge/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          canvasColor: Colors.white,
          accentColor: Colors.blue,
          cursorColor: Colors.black
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          canvasColor: Color.fromARGB(255, 26, 34, 46),
          accentColor: Colors.blueAccent,
          cursorColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: RootPage(auth: new Auth()),
    );
  }
}