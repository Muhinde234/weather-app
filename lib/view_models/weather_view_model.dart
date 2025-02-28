import 'package:flutter/material.dart';
import '../model/weather.dart';
import '../services/weatherlink.dart';

class WeatherViewModel extends ChangeNotifier {
  Weather? _weatherData;
  final _weatherlinkData = Weatherlink();

  bool isLoading = true;
  String? errorMessage;

  IconData get icon {
    if (_weatherData == null) return Icons.wb_sunny_outlined;

    final temp = _weatherData!.temperature;

    if (temp >= 85) {
      return Icons.wb_sunny;
    }

    if (temp <= 32) {
      return Icons.ac_unit;
    }

    if (humidity > 80 && temp > 32 && temp < 75) {
      if (windSpeed > 15) {
        return Icons.thunderstorm;
        return Icons.water_drop;
      }
    }

    if (windSpeed > 20) {
      return Icons.air;
    }

    if (humidity > 60 && humidity <= 80) {
      return Icons.cloud;
    }

    if (temp > 60 && temp < 85) {
      return Icons.cloud_queue;
    }

    return Icons.wb_sunny_outlined;
  }

  int get currentTemp {
    return _weatherData?.temperature ?? 0;
  }

  int get feelsLike {
    return _weatherData?.feelsLikeTemperature ?? 0;
  }

  String get windDirection {
    if (_weatherData?.windDirection == null) return "N/A";

    final Map<String, String> directionArrows = {
      'N': '↓',
      'NE': '↙',
      'E': '←',
      'SE': '↖',
      'S': '↑',
      'SW': '↗',
      'W': '→',
      'NW': '↘',
      'Variable': '↔',
    };

    final direction = _weatherData!.windDirection;
    final arrow = directionArrows[direction] ?? '';

    return "$arrow $direction";
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
