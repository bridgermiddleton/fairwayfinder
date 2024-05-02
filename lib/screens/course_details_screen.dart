import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_page_screen.dart';

class CourseDetailsPage extends StatefulWidget {
  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  Location _location = Location();
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  static const LatLng _defaultLocation =
      LatLng(38.0293, -78.4767); // Charlottesville, Virginia
  LatLng _currentLocation = _defaultLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 10));
  }

  Future<void> _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      var locationData = await _location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });
    } else {
      setState(() {
        _currentLocation =
            _defaultLocation; // Use Charlottesville if permission not granted
      });
    }

    // Ensure the map centers on the current or default location
    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 10));
  }

  void _searchNearbyGolfCourses(String query) async {
    var url =
        Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
      'query': 'golf course in $query',
      'location': '${_currentLocation.latitude},${_currentLocation.longitude}',
      'radius': '24140', // 15 miles in meters
      'key': 'AIzaSyCvrSjE9vnztWzamdw7vBkYfC2sc2_PkVU',
    });

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _markers.clear();
        for (var result in data['results']) {
          final marker = Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(result['geometry']['location']['lat'],
                result['geometry']['location']['lng']),
            infoWindow: InfoWindow(title: result['name']),
          );
          _markers.add(marker);
        }
        // Zoom to include all markers
        if (_markers.isNotEmpty) {
          _mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
                _boundsFromLatLngList(_markers.map((m) => m.position).toList()),
                50),
          );
        }
      });
    } else {
      print('Failed to fetch golf courses: ${response.body}');
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty, 'Cannot create bounds from empty list.');
    double x0 = list.first.latitude;
    double x1 = list.first.latitude;
    double y0 = list.first.longitude;
    double y1 = list.first.longitude;

    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006747),
        title:
            Text('FairwayFinder', style: TextStyle(color: Color(0xFFFFDF00))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle, color: Color(0xFFFFDF00)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.golf_course, color: Color(0xFFFFDF00)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => CourseDetailsPage()));
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      hintText: 'Enter a city',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State/Country',
                      hintText: 'Enter a state/country',
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_cityController.text.isNotEmpty &&
                  _stateController.text.isNotEmpty) {
                _searchNearbyGolfCourses(
                    _cityController.text + ', ' + _stateController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color(0xFF006747), // Background color // Text color
            ),
            child: Text(
              'Search',
              style: TextStyle(color: Color(0xFFFFDF00)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchNearbyGolfCourses("near me");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color(0xFF006747), // Background color // Text color
            ),
            child: Text('Find Courses Near Me',
                style: TextStyle(color: Color(0xFFFFDF00))),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 10,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
