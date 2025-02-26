class Weather {
  final int windSpeed;
  final String windDirection;
  final int humidity;
  final int temperature;
  final int feelsLikeTemperature;
  final DateTime lastUpdated;

  Weather({
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.temperature,
    required this.feelsLikeTemperature,
  }) : lastUpdated = DateTime.now();

  factory Weather.fromWeatherlink(Map<String, dynamic> data) {
    int windSpeed = 0;
    String windDirection = 'N/A';
    int humidity = 0;
    int temperature = 0;
    double barPressure = 0.0;

    bool foundTemperature = false;
    bool foundHumidity = false;
    bool foundWindSpeed = false;
    bool foundWindDirection = false;

    if (data.containsKey('sensors')) {
      for (var sensor in data['sensors']) {
        if (sensor['sensor_type'] == 504 && sensor['data'].isNotEmpty) {
          var sensorData = sensor['data'][0];

          if (sensorData.containsKey('temp') && sensorData['temp'] != null) {
            temperature = sensorData['temp'].toInt();
            foundTemperature = true;
          }

          if (sensorData.containsKey('hum') && sensorData['hum'] != null) {
            humidity = sensorData['hum'].toInt();
            foundHumidity = true;
          }
        } else if (sensor['sensor_type'] == 45 && sensor['data'].isNotEmpty) {
          var sensorData = sensor['data'][0];

          if (sensorData.containsKey('wind_speed_last') &&
              sensorData['wind_speed_last'] != null) {
            windSpeed = sensorData['wind_speed_last'].toInt();
            foundWindSpeed = true;
          }

          if (sensorData.containsKey('wind_dir_last') &&
              sensorData['wind_dir_last'] != null) {
            windDirection = _getWindDirection(sensorData['wind_dir_last']);
            foundWindDirection = true;
          }
        } else if (sensor['sensor_type'] == 242 && sensor['data'].isNotEmpty) {
          var sensorData = sensor['data'][0];
          if (sensorData.containsKey('bar_sea_level') &&
              sensorData['bar_sea_level'] != null) {
            barPressure = sensorData['bar_sea_level'].toDouble();
          }
        }
      }

      if (!foundTemperature ||
          !foundHumidity ||
          !foundWindSpeed ||
          !foundWindDirection) {
        for (var sensor in data['sensors']) {
          if (sensor['sensor_type'] == 45 && sensor['data'].isNotEmpty) {
            var sensorData = sensor['data'][0];

            if (!foundWindSpeed) {
              if (sensorData.containsKey('wind_speed_avg_last_1_min') &&
                  sensorData['wind_speed_avg_last_1_min'] != null) {
                windSpeed = sensorData['wind_speed_avg_last_1_min'].toInt();
                foundWindSpeed = true;
              } else if (sensorData.containsKey('wind_speed_avg_last_2_min') &&
                  sensorData['wind_speed_avg_last_2_min'] != null) {
                windSpeed = sensorData['wind_speed_avg_last_2_min'].toInt();
                foundWindSpeed = true;
              } else if (sensorData.containsKey('wind_speed_hi_last_2_min') &&
                  sensorData['wind_speed_hi_last_2_min'] != null) {
                windSpeed = sensorData['wind_speed_hi_last_2_min'].toInt();
                foundWindSpeed = true;
              }
            }

            if (!foundWindDirection) {
              if (sensorData.containsKey('wind_dir_scalar_avg_last_1_min') &&
                  sensorData['wind_dir_scalar_avg_last_1_min'] != null) {
                windDirection = _getWindDirection(
                  sensorData['wind_dir_scalar_avg_last_1_min'],
                );
                foundWindDirection = true;
              } else if (sensorData.containsKey(
                    'wind_dir_at_hi_speed_last_2_min',
                  ) &&
                  sensorData['wind_dir_at_hi_speed_last_2_min'] != null) {
                windDirection = _getWindDirection(
                  sensorData['wind_dir_at_hi_speed_last_2_min'],
                );
                foundWindDirection = true;
              }
            }

            if (!foundTemperature &&
                sensorData.containsKey('wind_chill') &&
                sensorData['wind_chill'] != null) {
              temperature = sensorData['wind_chill'].toInt();
              foundTemperature = true;
            }
          }
        }
      }
    }

    int feelsLikeTemperature = temperature;

    bool foundFeelsLike = false;

    if (data.containsKey('sensors')) {
      for (var sensor in data['sensors']) {
        if (sensor['sensor_type'] == 45 && sensor['data'].isNotEmpty) {
          var sensorData = sensor['data'][0];

          if (temperature <= 50 &&
              sensorData.containsKey('wind_chill') &&
              sensorData['wind_chill'] != null) {
            feelsLikeTemperature = sensorData['wind_chill'].toInt();
            foundFeelsLike = true;
          } else if (temperature >= 80 &&
              sensorData.containsKey('heat_index') &&
              sensorData['heat_index'] != null) {
            feelsLikeTemperature = sensorData['heat_index'].toInt();
            foundFeelsLike = true;
          } else if (sensorData.containsKey('thw_index') &&
              sensorData['thw_index'] != null) {
            feelsLikeTemperature = sensorData['thw_index'].toInt();
            foundFeelsLike = true;
          }
        }
      }
    }

    if (!foundFeelsLike) {
      if (temperature <= 50 && windSpeed > 3) {
        feelsLikeTemperature = (temperature - (windSpeed * 0.7)).toInt();
      } else if (temperature >= 80 && humidity > 40) {
        feelsLikeTemperature = (temperature + (humidity * 0.1)).toInt();
      }
    }

    if (temperature == 0 && !foundTemperature) {
      temperature = 72;
      feelsLikeTemperature = 72;
    }

    if (humidity == 0 && !foundHumidity) {
      humidity = 45;
    }

    if (windSpeed == 0 && !foundWindSpeed) {
      windSpeed = 5;
    }

    if (windDirection == 'N/A' && !foundWindDirection) {
      windDirection = 'Variable';
    }

    return Weather(
      windSpeed: windSpeed,
      windDirection: windDirection,
      humidity: humidity,
      temperature: temperature,
      feelsLikeTemperature: feelsLikeTemperature,
    );
  }

  static String _getWindDirection(num degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    int index = ((degrees % 360) / 45).round();
    return directions[index];
  }
}
