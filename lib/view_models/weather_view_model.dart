import 'package:flutter/material.dart';
import '../model/weather.dart';
import '../services/weatherlink.dart';

class WeatherViewModel extends ChangeNotifier {
  Weather? _weatherData;
  final _weatherlinkData = Weatherlink();

  bool isLoading = true;
  String? errorMessage;

  IconData get icon {
    return Icons.wb_sunny_outlined;
  }

  int get currentTemp {
    return _weatherData?.temperature ?? 0;
  }

  int get feelsLike {
    return _weatherData?.feelsLikeTemperature ?? 0;
  }

  String get windDirection {
    return _weatherData?.windDirection ?? "N/A";
  }

  int get windSpeed {
    return _weatherData?.windSpeed ?? 0;
  }

  int get humidity {
    return _weatherData?.humidity ?? 0;
  }

  DateTime get lastUpdated {
    return _weatherData?.lastUpdated ?? DateTime.now();
  }

  WeatherViewModel() {
    refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final weatherData = await _weatherlinkData.getWeather();

      if (weatherData != null) {
        _weatherData = weatherData;
      } else {
        errorMessage = "Failed to load weather data";
      }
    } catch (error) {
      errorMessage = "Error: $error";
      print("Error fetching weather data: $error");
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));

      isLoading = false;
      notifyListeners();
    }
  }
}
