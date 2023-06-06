//import libraries
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart';

import 'dart:math' show cos, sqrt, asin;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}
// Create a Landmark class to hold information about a landmark
class Landmark {
  final String name;
  final LatLng coordinates;
  int waiting;

  Landmark({required this.name, required this.coordinates, this.waiting = 0});
}


class _MapViewState extends State<MapView> {
  int waiting = 0;
  var currDocId;
  bool showOptions = false;
  LatLng _initialLocation = LatLng(15.4226, 73.9798);
  late MapController mapController;
  late Position _currentPosition;

  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  // Initialize landmarks with their name and coordinates
  List<Landmark> landmarks = [
    Landmark(
        name: 'IIT Goa Campus',
        coordinates: LatLng(15.4226, 73.9798)),
    Landmark(
        name: 'GEC Hostel',
        coordinates: LatLng(15.421869, 73.971312)),
    Landmark(
        name: 'Farmagudi Residency',
        coordinates: LatLng(15.422364, 73.963534)),
    Landmark(
      name: 'Landmark 1',
      coordinates: LatLng(15.405310, 74.016470)),
  Landmark(
      name: 'Landmark 2',
      coordinates: LatLng(15.403400, 74.013270)),
  Landmark(
      name: 'Landmark 3',
      coordinates: LatLng(15.406900, 74.015560)),
  ];
  List<Marker> markers = [];
  Marker _waitMark = Marker(
    point: LatLng(15.4226, 73.9798),
    builder: (ctx) => Container(
      child: Icon(Icons.location_on, color: Colors.red),
    ),
  );
  // Create a ListTile for a given landmark
  Widget _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
  }
  // Add markers for each landmark to the map
void _addLandmarkMarkers() {
  landmarks.asMap().forEach((index, landmark) {
    Marker marker = Marker(
      point: landmark.coordinates,
      builder: (ctx) => Container(
        child: Stack(
          children: [
            Icon(Icons.location_on, color: Colors.red),
            Positioned(
              top: -5,
              left: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    markers.add(marker);
  });
}
// Update the waiting time at a given landmark
void _updateWaiting(int index) {
  setState(() {
    landmarks[index].waiting += 1;
  });
}


  late PolylinePoints polylinePoints;
  List<Polyline> polylines = [];
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Create a TextField widget for user input
  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }
// Determine user's current position
Future<Position> _determinePosition() async {
  bool serviceEnabled = false;
  LocationPermission permission;
  Position position;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  position = await Geolocator.getCurrentPosition();
  return position;
}

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    polylinePoints = PolylinePoints();
    _addLandmarkMarkers();
    _determinePosition().then((position) {
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
        _currentPosition = position;
        markers.add(
          Marker(
            point: LatLng(position.latitude, position.longitude),
            builder: (ctx) => Container(
              child: Icon(Icons.location_on, color: Colors.blue),
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    startAddressController.dispose();
    destinationAddressController.dispose();
    startAddressFocusNode.dispose();
    desrinationAddressFocusNode.dispose();
    super.dispose();
  }
// Build method for the StatefulWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Rider App')),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: _initialLocation,
              zoom: 14.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(markers: markers),
              PolylineLayerOptions(polylines: polylines),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100,
                      child: InkWell(
                        splashColor: Colors.blue,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.add),
                        ),
                        onTap: () {
                          setState(() {
                            showOptions = (showOptions ? false : true);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange.shade100,
                    child: InkWell(
                      splashColor: Colors.orange,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        mapController.move(
                          LatLng(
                            _currentPosition.latitude,
                            _currentPosition.longitude,
                          ),
                          18.0,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showOptions)
            SafeArea(
               child: Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: EdgeInsets.only(
  left: MediaQuery.of(context).size.width * 0.15, // 10% of screen width
  top: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
  bottom: MediaQuery.of(context).size.height * 0.02, // 10% of screen height
  right: MediaQuery.of(context).size.width * 0.05, // 5% of screen width
),

      child: Container(
        padding: const EdgeInsets.only(
            left: 50, top: 100, bottom: 100, right: 20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20.0), // Add rounded edges
        ),
        child: Column(
          children: [
            for (int i = 0; i < landmarks.length; i++)
              _tile(
                (i + 1).toString(),
                landmarks[i].name,
                Icons.location_on,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}