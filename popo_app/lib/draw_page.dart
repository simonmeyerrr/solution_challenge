import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutterapp/painter.dart';
import 'package:flutterapp/width_dialog.dart';

import 'color_dialog.dart';
import 'dart:ui' as ui;

class DrawPage extends StatefulWidget {
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
        backgroundColor: Colors.green,
      ),
      body: Container(
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
                backgroundColor: Colors.green,
                mini: true,
                child: Icon(Icons.save),
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
                curve: Interval(0.0, 1.0 - 1 / 5 / 2.0, curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: "btnDraw0",
                backgroundColor: Colors.green,
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
                backgroundColor: Colors.green,
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
                backgroundColor: Colors.green,
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
                backgroundColor: Colors.green,
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
            child:           FloatingActionButton(
              heroTag: "btnDraw4",
              backgroundColor: Colors.green,
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
}
