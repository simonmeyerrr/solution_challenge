import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:solution_challenge/popo/draw_page.dart';
import 'package:solution_challenge/popo/side_menu.dart';
import 'package:solution_challenge/popo/splash_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:location/location.dart';
import 'package:solution_challenge/services/authentication.dart';
import 'location.dart' as locations;

class MyHomePage extends StatefulWidget {
  MyHomePage({this.auth, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  State<MyHomePage> createState() => MyAppState();
}

class MyAppState extends State<MyHomePage> {

  Completer<GoogleMapController> _mapController = Completer();
  final Map<String, Marker> _markers = {};

  BitmapDescriptor customMarkerRed;
  BitmapDescriptor customMarkerBlue;
  BitmapDescriptor customMarkerGreen;
  BitmapDescriptor customMarkerYellow;

  static LatLng _cameraPosition;
  Color slidingPanelColor = Colors.white;
  Color dotColor = Colors.black38;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PanelController _pc = new PanelController();

  String _mapStyle;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)),
        'assets/marker_red.png')
        .then((d) {
      customMarkerRed = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)),
        'assets/marker_blue.png')
        .then((d) {
      customMarkerBlue = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)),
        'assets/marker_green.png')
        .then((d) {
      customMarkerGreen = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(8, 8)),
        'assets/marker_yellow.png')
        .then((d) {
      customMarkerYellow = d;
    });
    rootBundle.loadString("assets/darkMap.json").then((string) {
      _mapStyle = string;
    });
    _initLocalisation();
  }

  @override
  Widget build(BuildContext context) {
    //Handle dark mode
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (isDark) {
      slidingPanelColor = Color.fromARGB(255,26,34,46);
      dotColor = Colors.white54;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 0,
        maxHeight: 700,
        color: slidingPanelColor,
        backdropEnabled: true,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        panel: Container (
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              _carousel(),
              Divider(
                color: Theme.of(context).cursorColor,
                height: 50,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                height: 360,
                child: _scrollView()
              )
            ],
          )
        ),
        body: _cameraPosition == null ? SplashScreen() : _body()
      ),
      drawer: NavDrawer(auth: widget.auth, logoutCallback: widget.logoutCallback),
    );
  }

  Widget _body() {
    GoogleMapController mapController;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Stack(
      children: <Widget>[
        GoogleMap(
          zoomGesturesEnabled: true,
          compassEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _cameraPosition,
            zoom: 18.0,
          ),
          onMapCreated: (GoogleMapController controller) async {
            if (isDark) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
            }
            final googleOffices = await locations.getGoogleOffices();
            setState(() {
              _markers.clear();
              for (final office in googleOffices.offices) {
                final _icon = selectRandomMarker();
                final marker = Marker(
                  icon: _icon,
                  markerId: MarkerId(office.name),
                  position: LatLng(office.lat, office.lng),
                  infoWindow: InfoWindow(
                    title: office.name,
                    snippet: office.address,
                  ),
                );
                _markers[office.name] = marker;
              }
            });
            setState(() {
              _mapController.complete(controller);
            });
          },
          markers: _markers.values.toSet(),
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
                  child: const Icon(Icons.brush, size: 36.0),
                  onPressed: () {
                    Navigator.push(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context) => DrawPage(auth: widget.auth)));
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
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
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

  Widget _carousel() {
    return Container(
      height: 260,
      child: Swiper(
        //Picture H 150 | W 250
        itemHeight: 150,
        itemBuilder: (BuildContext context, int index){
          var newI = index + 1;
          return SvgPicture.asset(
              "assets/Caroussel$newI.svg",
          );
        },
        itemCount: 3,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
                activeColor: Theme.of(context).accentColor,
                color: dotColor,
                size: 8,
                activeSize: 10)
        ),
        viewportFraction: 0.8,
        scale: 0.9,
      )
    );
  }

  Widget _scrollView() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('He\'d have you all unravel at the'),
                color: Colors.blue[100],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Heed not the rabble'),
                color: Colors.blue[200],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Sound of screams but the'),
                color: Colors.blue[300],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Who scream'),
                color: Colors.blue[400],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Revolution is coming...'),
                color: Colors.blue[500],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Revolution, they...'),
                color: Colors.blue[600],
              ),
            ],
          ),
        ),
      ],
    );
  }

  BitmapDescriptor selectRandomMarker() {
    final _random = new Random();
    final r = _random.nextInt(4);

    if (r == 0)
      return customMarkerRed;
    else if (r == 1)
      return  customMarkerGreen;
    else if (r == 2)
      return customMarkerBlue;
    else
      return customMarkerYellow;
  }
}