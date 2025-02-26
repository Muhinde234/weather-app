// import 'package:flutter/material.dart';
// import '../model/weather.dart';
// import '../services/weatherlink.dart';

// class WeatherViewModel extends ChangeNotifier {
//   Weather? _weatherData;
//   final _weatherlinkData = Weatherlink();

//   bool isLoading = true;

//   IconData get icon {
//     return Icons.wb_sunny_outlined;
//   }

//   int get currentTemp {
//     return _weatherData?.temperature ?? 0;
//   }

//   int get feelsLike {
//     return _weatherData?.feelsLikeTemperature ?? 0;
//   }

//   String get windDirection {
//     return 'E';
//   }

//   int get windSpeed {
//     return _weatherData?.windSpeed ?? 0;
//   }

//   int get humidity {
//     return _weatherData?.humidity ?? 0;
//   }

//   DateTime get lastUpdated {
//     return _weatherData?.lastUpdated ?? DateTime.now();
//   }

//   WeatherViewModel() {
//     refresh();
//   }

//   Future<void> refresh() async {
//     isLoading = true;
//     notifyListeners();

//     final weatherFuture = _weatherlinkData.getWeather();
//     final timingFuture = Future.delayed(const Duration(milliseconds: 800));
//     _weatherData = await weatherFuture;

//     // for visualization purposes
//     await timingFuture;

//     isLoading = false;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../model/weather.dart';
import '../services/weatherlink.dart';

class WeatherViewModel extends ChangeNotifier {
  Weather? _weatherData;
  final _weatherlinkData = Weatherlink();

  bool isLoading = true;

  // Getters to expose weather data
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
    notifyListeners();

    final weatherFuture = _weatherlinkData.getWeather();
    final timingFuture = Future.delayed(const Duration(milliseconds: 800));
    _weatherData = await weatherFuture;

    await timingFuture;

    isLoading = false;
    notifyListeners();
  }
}
