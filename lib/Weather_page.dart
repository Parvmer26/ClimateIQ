import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_application/Weather_service.dart';
import 'package:weather_application/Weather_model.dart';
import 'package:weather_application/permission_page.dart';
import 'city_search_page.dart';
import 'dart:io' show Platform;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final _weatherService = WeatherService('75776f7a2a6ac77c81eb960380b7528f');
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _initializeNotifications();
    _fetchWeather();
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status != PermissionStatus.granted) {
        await Permission.notification.request();
      }
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');


    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _fetchWeather() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PermissionPage(onPermissionGranted: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WeatherPage()),
            );
          }),
        ),
      );
      return;
    }

    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });

      _showWeatherNotification(weather.mainCondition);
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  void _showWeatherNotification(String condition) {
    String message;

    switch (condition.toLowerCase()) {
      case 'rain':
        message = "It's raining. Don't forget your umbrella!";
        break;
      case 'clear':
        message = "Sunny skies. Perfect day to go out!";
        break;
      case 'clouds':
        message = "Cloudy skies. A calm weather ahead!";
        break;
      case 'thunderstorm':
        message = "Thunderstorms expected. Stay safe!";
        break;
      case 'mist':
      case 'fog':
        message = "Low visibility. Drive safely!";
        break;
      default:
        message = "Current weather: $condition";
    }

    flutterLocalNotificationsPlugin.show(
      0,
      'ClimateIQ Weather Alert',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weather_channel_id',
          'Weather Alerts',
          channelDescription: 'Notifications based on local weather',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    print("Notification Sent: $message");
  }

  void _fetchWeatherByCity(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      //  No notification on city search
    } catch (e) {
      print("Error fetching weather for $cityName: $e");
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/loading3.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/suncloud.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        onPressed: () async {
          final selectedCity = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CitySearchPage()),
          );
          if (selectedCity != null) {
            _fetchWeatherByCity(selectedCity);
          }
        },
        child: const Icon(Icons.search, color: Colors.white, size: 32),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.location_pin,
                      color: Colors.grey.shade700, size: 30),
                  Text(
                    _weather?.cityName ?? "Fetching City..",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'abels',
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Column(
  children: [
    Text(
      _weather?.temperature != null
          ? '${_weather!.temperature.round()}°C'
          : '--°C',
      style: TextStyle(
        color: Colors.grey.shade300,
        fontFamily: 'abels',
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
    ),
    Text(
      _weather?.mainCondition ?? "Fetching weather...",
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: 'abels',
        fontSize: 25,
        fontWeight: FontWeight.w700,
      ),
    ),
  ],
)
            ],
          ),
        ),
      ),
    );
  }
}
