import 'package:flutter/material.dart';
import 'package:flutterapp/draw_page.dart';
import 'package:flutterapp/side_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppState(),
    );
  }
}

class MyAppState extends StatelessWidget {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PanelController _pc = new PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 0,
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: _body()
      ),
      drawer: NavDrawer(),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  child: FloatingActionButton(
                      heroTag: "mainBtnLeft",
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.menu, size: 36.0),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      }
                  )
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  child: FloatingActionButton(
                    heroTag: "mainBtnCenter",
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.bookmark_border, size: 36.0),
                    onPressed: () {
                      _pc.open();
                    },
                  )
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  child: FloatingActionButton(
                    heroTag: "mainBtnRight",
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.brush, size: 36.0),
                    onPressed: () {
                      Navigator.push(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context) => DrawPage()));
                    },
                  )
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                  child: FloatingActionButton(
                    heroTag: "mainBtnTop",
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.brush, size: 36.0),
                    //onPressed: _getLocation,
                  )
              ),
            )
        ),
      ],
    );
  }
}