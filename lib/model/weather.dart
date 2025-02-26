// class Weather {
//   late final int windSpeed;
//   late final int windDirection;
//   late final int humidity;
//   late final int temperature;
//   late final int feelsLikeTemperature;
//   final DateTime lastUpdated;

//   Weather.fromWeatherlink(Map<String, dynamic> data)
//     : lastUpdated = DateTime.now() {
//     windSpeed = 90;
//     windDirection = 91;
//     humidity = 92;
//     temperature = 93;
//     feelsLikeTemperature = 94;
//   }
// }

class Weather {
  final int windSpeed;
  final String windDirection;
  final int humidity;
  final int temperature;
  final int feelsLikeTemperature;
  final DateTime lastUpdated;

  // Constructor for assigning values
  Weather({
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.temperature,
    required this.feelsLikeTemperature,
  }) : lastUpdated = DateTime.now();

  // Factory constructor to create a Weather object from API response
  factory Weather.fromWeatherlink(Map<String, dynamic> data) {
    return Weather(
      windSpeed: data['wind_speed'] ?? 0,
      windDirection: data['wind_direction'] ?? 'N/A',
      humidity: data['humidity'] ?? 0,
      temperature: data['temperature'] ?? 0,
      feelsLikeTemperature: data['feels_like_temperature'] ?? 0,
    );
  }
}
