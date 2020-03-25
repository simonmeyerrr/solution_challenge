import 'package:flutter/material.dart';

class DrawDetails extends StatelessWidget {
  DrawDetails({this.imgPath});

  final String imgPath;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Drawing Details"),
    backgroundColor: Theme.of(context).accentColor,
    ),
    backgroundColor: Colors.white,
    body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              imgPath,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
