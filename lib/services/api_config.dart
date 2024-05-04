import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    String jsonString = await rootBundle.loadString('assets/config.json');
    _config = json.decode(jsonString);
  }

  static String get mapsApiKey {
    return _config['MAPS_KEY'];
  }
}
