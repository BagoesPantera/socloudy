import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Weather {
  final String weather;
  final double temp;
  final String location;

  final double windSpd;
  final double windGst;
  final int hum;
  final int cloud;
  final double vis;
  final double uv;


  Weather({
    required this.weather,
    required this.temp,
    required this.location,

    required this.windSpd,
    required this.windGst,
    required this.hum,
    required this.cloud,
    required this.vis,
    required this.uv,


  });

  factory Weather.fromJson(Map<String, dynamic> json) {

    return Weather(
      weather: json['current']['condition']['text'],
      temp: json['current']['temp_c'],
      location: json['location']['name'],

      windSpd: json['current']['wind_kph'],
      windGst: json['current']['gust_kph'],
      hum: json['current']['humidity'],
      cloud: json['current']['cloud'],
      vis: json['current']['vis_km'],
      uv: json['current']['uv'],

    );
  }
}

// https://pub.dev/packages/geolocator#example
Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
}

// https://docs.flutter.dev/cookbook/networking/fetch-data#complete-example
Future<Weather> fetchWeather() async {
  Position userLocation = await _getGeoLocationPosition();
  String? key = dotenv.env['API_KEY'];
  String url = "http://api.weatherapi.com/v1/forecast.json?key=$key&q=${userLocation.latitude.toString()},${userLocation.longitude.toString()}&days=3";

  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonObject = json.decode(response.body);
    return Weather.fromJson(jsonObject);
  } else {
    throw Exception('Failed to load weather');
  }
}