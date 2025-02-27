// lib/models/weather_data.dart
class WeatherData {
  final double temperature;
  final double humidity;
  final double illuminance;
  final int rainAnalog;
  final int rainDigital;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.illuminance,
    required this.rainAnalog,
    required this.rainDigital,
  });

  factory WeatherData.fromMap(Map<dynamic, dynamic> data) {
    return WeatherData(
      temperature: (data['temperature'] as num?)?.toDouble() ?? -999.0,
      humidity: (data['humidity'] as num?)?.toDouble() ?? -999.0,
      illuminance: (data['illuminance'] as num?)?.toDouble() ?? -999.0,
      rainAnalog: (data['rain_analog'] as int?) ?? -1,
      rainDigital: (data['rain_digital'] as int?) ?? -1,
    );
  }

  factory WeatherData.fallback() {
    return WeatherData(
      temperature: -999.0,
      humidity: -999.0,
      illuminance: -999.0,
      rainAnalog: -1,
      rainDigital: -1,
    );
  }

  bool isValid() {
    return temperature != -999.0 &&
        humidity != -999.0 &&
        illuminance != -999.0 &&
        rainAnalog != -1 &&
        rainDigital != -1;
  }
}