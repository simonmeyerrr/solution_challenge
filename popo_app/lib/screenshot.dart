import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static GlobalKey previewContainer = new GlobalKey();
  int _counter = 0;
  Uint8List screenShot;


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
        key: previewContainer,
        child: new Scaffold(
          appBar: new AppBar(

            title: new Text(widget.title),
          ),
          body: new Center(
            child: new Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),

                _buildChild(),
                new Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
                //new Image.memory(screenShot),
                new RaisedButton(
                  onPressed: takeScreenShot,
                  child: const Text('Take a Screenshot'),
                ),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }

  Widget _buildChild() {
    if (screenShot != null) {
      return new Image.memory(screenShot, height: 100, width: 50);
    }
    return new Text("null");
  }

  takeScreenShot() async{
    RenderRepaintBoundary boundary = previewContainer.currentContext
        .findRenderObject();
    if (boundary.debugNeedsPaint) {
      Timer(Duration(seconds: 1), () => takeScreenShot());
      return null;
    }
    ui.Image img = await boundary.toImage();
    ByteData test = await img.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      screenShot = test.buffer.asUint8List();
    });
  }
}