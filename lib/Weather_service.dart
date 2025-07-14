import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'Weather_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASIC_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityname) async{
    final response = await http.get(Uri.parse('$BASIC_URL?q=$cityname&appid=$apikey&units=metric'));

    if (response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('failed to load weather data');
    }
  }
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    //   fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //   convert it into placemarks
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    //   extract city name from 1st placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
