import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _searchGolfCourses(String city, String state) async {
    var query = 'golf course in $city, $state';
    var url =
        Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
      'query': query,
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
        if (data['results'].isNotEmpty) {
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

    // Initialize bounds with the first point in the list
    var x0 = list.first.latitude;
    var x1 = list.first.latitude;
    var y0 = list.first.longitude;
    var y1 = list.first.longitude;

    // Extend bounds to include each point
    for (var latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  void _getUserLocation() async {
    var locationData = await _location.getLocation();
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude!, locationData.longitude!), 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Golf Courses'),
        centerTitle: true,
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
                _searchGolfCourses(_cityController.text, _stateController.text);
              }
            },
            child: Text('Search'),
          ),
          ElevatedButton(
            onPressed: () => _searchGolfCourses("near me", ""),
            child: Text('Find Courses Near Me'),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: LatLng(0, 0), zoom: 10),
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
