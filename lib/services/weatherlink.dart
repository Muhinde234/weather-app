import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather.dart';

// class Weatherlink {
//   final httpClient = http.Client();

//   Future<Weather> getWeather() async {
//     final httpPayload = <String, dynamic>{};
//     return Weather.fromWeatherlink(httpPayload);
//   }
// }

class Weatherlink {
  static const String _apiUrl =
      "https://us-central1-oc-weather-25.cloudfunctions.net/weather";

  Future<Weather?> getWeather() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromWeatherlink(data);
      } else {
        print(
          "Failed to fetch weather data. Status code: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}
