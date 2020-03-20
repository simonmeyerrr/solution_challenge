import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/draw_page.dart';
import 'package:flutterapp/side_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyAppState();
}
class MyAppState extends State<MyHomePage> {

  Completer<GoogleMapController> _mapController = Completer();

  static LatLng _cameraPosition;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    _initLocalisation();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController.complete(controller);
    });
  }

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
        body: _cameraPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : _body()
      ),
      drawer: NavDrawer(),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _cameraPosition,
            zoom: 18.0,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: false
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                    heroTag: "mainBtnMenu",
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
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  heroTag: "mainBtnEvents",
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.account_balance, size: 36.0),
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
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  heroTag: "mainBtnDraw",
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.brush, size: 36.0),
                  onPressed: () {
                    Navigator.push(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context) => DrawPage()));
                  },
                ),
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 26, 100),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  heroTag: "mainBtnGeoloc",
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.my_location, size: 20.0),
                  onPressed: _getLocationAndMove
                )
              ),
            )
        ),
      ],
    );
  }

  void _initLocalisation() async {
    Position position = await Geolocator().getCurrentPosition();
    setState(() {
      _cameraPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _getLocationAndMove() async {
    final GoogleMapController controller = await _mapController.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
      bearing: 0,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18.0,
    ),
    ));
  }
}