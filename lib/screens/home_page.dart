import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_page_screen.dart';
import 'couse_details_page.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      'key': 'your-google-maps-api',
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
            infoWindow: InfoWindow(
              title: result['name'],
              onTap: () =>
                  _onTapCourse(result['name'], result['formatted_address']),
            ),
          );
          _markers.add(marker);
        }
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

  void _onTapCourse(String name, String formattedAddress) {
    // Typical formatted address: "123 Main St, Springfield, IL 12345, USA"
    // Split the string by commas and extract relevant parts
    List<String> parts = formattedAddress.split(',');
    String city = '';
    String state = '';

    if (parts.length >= 3) {
      city = parts[1].trim(); // The second part should be the city
      state = parts[2].trim().split(
          ' ')[0]; // The third part should be state followed by postal code
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CourseDetailsPage(name: name, city: city, state: state)));
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
      appBar: CommonWidgets.buildAppBar(context),
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
                      labelText: 'State',
                      hintText: 'Enter a state',
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
