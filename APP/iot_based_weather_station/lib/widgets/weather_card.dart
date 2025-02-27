import 'package:flutter/material.dart';
import 'package:iot_based_weather_station/models/weather_data.dart';
import 'dart:ui';

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherCard({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          minHeight: 350.0,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.black.withOpacity(0.12))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildWeatherIcon(context),
                          const SizedBox(height: 16),
                          Text(
                            weatherData.isValid()
                                ? "It's ${weatherCondition(weatherData)}"
                                : "N/A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTemperature(context),
                          const SizedBox(height: 24),
                          _buildDetailsRow(context),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String weatherCondition(WeatherData weatherData) {
    if (!weatherData.isValid()) return 'N/A';
    if (weatherData.temperature > 30) return 'Sunny';
    if (weatherData.rainDigital == 0) return 'Rainy';
    return 'Cloudy';
  }

  Widget _buildWeatherIcon(BuildContext context) {
    String iconPath;
    if (!weatherData.isValid()) {
      iconPath = 'assets/icons/error.png';
    } else if (weatherData.temperature > 30) {
      iconPath = 'assets/icons/sunny.png';
    } else if (weatherData.rainDigital == 0) {
      iconPath = 'assets/icons/rainy.png';
    } else {
      iconPath = 'assets/icons/partly_cloudy.png';
    }

    return Image.asset(
      iconPath,
      width: 150,
      height: 150,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, color: Colors.red, size: 75);
      },
    );
  }

  Widget _buildTemperature(BuildContext context) {
    String temperatureString = weatherData.isValid()
        ? '${weatherData.temperature.toStringAsFixed(1)}°'
        : 'N/A';

    return Text(
      temperatureString,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 64,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            weatherData.isValid()
                ? '${weatherData.illuminance.toStringAsFixed(2)} lux'
                : 'N/A',
            'Sun',
            'assets/icons/sun_small.png',
          ),
          _buildDetailItem(
            weatherData.isValid()
                ? '${weatherData.humidity.toStringAsFixed(0)}%'
                : 'N/A',
            'Humidity',
            'assets/icons/humidity_small.png',
          ),
          _buildDetailItem(
            weatherData.isValid()
                ? (weatherData.rainDigital == 1 ? 'No Rain' : 'Rain')
                : 'N/A',
            'Chance of rain',
            'assets/icons/rain_small.png',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String value, String label, String iconPath) {
    return Column(
      children: [
        Image.asset(
          iconPath,
          width: 45,
          height: 45,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red, size: 48);
          },
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}