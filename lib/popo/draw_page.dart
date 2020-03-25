import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:solution_challenge/popo/painter.dart';
import 'package:solution_challenge/popo/width_dialog.dart';
import 'package:solution_challenge/services/authentication.dart';
import 'color_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui' as ui;

class DrawPage extends StatefulWidget {
  DrawPage({this.auth});

  final BaseAuth auth;

  @override
  DrawPageState createState() => new DrawPageState();
}

class DrawPageState extends State<DrawPage> with TickerProviderStateMixin {
  AnimationController controller;
  List<Offset> points = <Offset>[];
  Color color = Colors.black;
  StrokeCap strokeCap = StrokeCap.round;
  double strokeWidth = 5.0;
  List<Painter> painters = <Painter>[];

  //Screenshot variable
  static GlobalKey previewContainer = new GlobalKey();
  Uint8List screenShot;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing"),
        backgroundColor: Theme.of(context).accentColor,
      ),
      backgroundColor: Colors.white,
      body: RepaintBoundary(
        key: previewContainer,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset localPosition = object.globalToLocal(details.localPosition);
              points = new List.from(points);
              points.add(localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => points.add(null),
          child: CustomPaint(
            painter: Painter(
                points: points,
                color: color,
                strokeCap: strokeCap,
                strokeWidth: strokeWidth,
                painters: painters),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton:
        Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          _buildChild(),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - 0 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDrawSave",
                mini: true,
                child: Icon(Icons.save),
                onPressed: takeScreenShot
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - 1 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDraw0",
                mini: true,
                child: Icon(Icons.undo),
                onPressed: () {
                  for (var i = 0; i < 20; i++) {
                    if (points.isNotEmpty) {
                      points.removeLast();
                    }
                  }
                  for (Painter painter in painters) {
                    painter.points.clear();
                  }
                },
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - 2 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDraw1",
                mini: true,
                child: Icon(Icons.clear),
                onPressed: () {
                  points.clear();
                  for (Painter painter in painters) {
                    painter.points.clear();
                  }
                },
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - 3 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDraw2",
                mini: true,
                child: Icon(Icons.lens),
                onPressed: () async {
                  double temp;
                  temp = await showDialog(context: context, builder: (context) => WidthDialog(strokeWidth: strokeWidth));
                  if (temp != null) {
                    setState(() {
                      painters.add(Painter(
                          points: points.toList(),
                          color: color,
                          strokeCap: strokeCap,
                          strokeWidth: strokeWidth));
                      points.clear();
                      strokeWidth = temp;
                    });
                  }
                },
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - 4 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDraw3",
                mini: true,
                child: Icon(Icons.color_lens),
                onPressed: () async {
                  Color temp;
                  temp = await showDialog(context: context, builder: (context) => ColorDialog());
                  if (temp != null) {
                    setState(() {
                      painters.add(Painter(
                        points: points.toList(),
                        color: color,
                        strokeCap: strokeCap,
                        strokeWidth: strokeWidth));
                      points.clear();
                      color = temp;
                    });
                  }
                }
              )
            )
          ),
          Container(
            height: 60,
            width: 60,
            child: FloatingActionButton(
              heroTag: "btnDraw4",
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.rotationZ(controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(Icons.brush, size: 36.0),
                  );
                },
              ),
              onPressed: () {
                if (controller.isDismissed) {
                  controller.forward();
                } else {
                  controller.reverse();
                }
              },
            )
          )
        ]
      ),
    );
  }

  Widget _buildChild() {
    if (screenShot != null) {
      return new Image.memory(screenShot, height: 300, width: 150);
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
    String uid = (await widget.auth.getCurrentUser()).uid;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(uid + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '-' + (math.Random.secure().nextInt(10999) + 1000).toString() + '.png');
    StorageUploadTask uploadTask = storageReference.putData(test.buffer.asUint8List());
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileURL = await storageReference.getDownloadURL();
    print(fileURL);
    Position position = await Geolocator().getCurrentPosition();
    final coordinates = new Coordinates(
        position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    DocumentReference doc = await Firestore.instance.collection('post').add({
      'uid': uid,
      'img': fileURL,
      'public': false,
      'loc': new GeoPoint(position.latitude, position.longitude),
      'adress': addresses.first.addressLine
    });
    print("Doc uploaded");
    print(doc);
  }
}
