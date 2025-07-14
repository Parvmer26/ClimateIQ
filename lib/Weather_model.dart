class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
