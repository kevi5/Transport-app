import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

// Flutter Map widget
class Flutter_Map extends StatefulWidget {
  Flutter_Map({Key? key}) : super(key: key);

  @override
  State<Flutter_Map> createState() => _Flutter_MapState();
}

class _Flutter_MapState extends State<Flutter_Map> {
  late MapController mapController;
  late LatLng _currentPosition;

  double _zoom = 12;
  bool _hasUserMovedMap = false;

  Location location = new Location();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> markers = [];
  LatLng _initialLocation = LatLng(15.422558762251272, 73.9825665794217);

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getCurrentLocation();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      mapController.move(_initialLocation, _zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: _initialLocation,
                zoom: _zoom,
                plugins: [
                  MarkerClusterPlugin(),
                ],
                onPositionChanged: (MapPosition pos, bool hasUserGesture) {
                  if (hasUserGesture) {
                    _hasUserMovedMap = true;
                  }
                },
              ),
              layers: [
                // Base map layer
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                // Marker cluster layer
                MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: Size(40, 40),
                  anchor: AnchorPos.align(AnchorAlign.center),
                  markers: markers,
                  polygonOptions: PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      onPressed: null,
                      backgroundColor: Colors.blueAccent,
                    );
                  },
                ),
                // Marker layer
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            ),
            // Zoom in and out buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Zoom in button
                    ClipOval(
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          splashColor: Colors.blue,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add, color: Colors.blue),
                          ),
                          onTap: () {
                            mapController.move(
                              _currentPosition,
                              _zoom + 1,
                            );
                            setState(() {
                              _zoom += 1;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
// Zoom out button
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100,
                        child: InkWell(
                          splashColor: Colors.blue,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove, color: Colors.blue),
                          ),
                          onTap: () {
                            mapController.move(
                              _currentPosition,
                              _zoom - 1,
                            );
                            setState(() {
                              _zoom -= 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
// Floating action button to go to the current location
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  mapController.move(_currentPosition, _zoom);
                },
                child: Icon(Icons.my_location),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Get the current location of the user
  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    } // Listen for location changes
    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      if (!_hasUserMovedMap) {
        // Only move the map if the user has not moved it
        mapController.move(_currentPosition, _zoom);
      }
      setState(() {
        markers.clear(); // Remove previous markers
        markers.add(Marker(
          width: 80.0,
          height: 80.0,
          point: _currentPosition,
          builder: (ctx) => Container(
            child: Icon(
              Icons.location_on,
              color: Colors.green,
            ),
          ),
        ));
      });
    });
  }
}
