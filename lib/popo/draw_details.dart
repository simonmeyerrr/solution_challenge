import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
    body: Stack(
        children: <Widget>[
          Image.network(
            imgPath,
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    height: 60,
                    width: 60,
                    child: FloatingActionButton(
                        heroTag: "btnAR",
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: const Icon(Icons.photo_camera, size: 36.0),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DrawAR(imgPath: imgPath,)));
                      },
                    )
                ),
              )
          ),
        ]
      ),
    );
  }
}

class DrawAR extends StatefulWidget {
  DrawAR({this.imgPath});

  final String imgPath;
  @override
  _DrawARState createState() => _DrawARState(imgPath: imgPath);
}

class _DrawARState extends State<DrawAR> {
  _DrawARState({this.imgPath});

  final String imgPath;
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing in real life"),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    _addCube(arCoreController);
  }

  Future<void> _addCube(ArCoreController controller) async {
    final material = ArCoreMaterial(
        color: Colors.white,
        textureBytes: await networkImageToByte(imgPath)
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 1, 0),
    );
    final node = ArCoreNode(
        shape: cube
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
