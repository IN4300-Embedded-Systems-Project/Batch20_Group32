// lib/screens/weather_screen.dart 
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_based_weather_station/models/weather_data.dart';
import 'package:iot_based_weather_station/widgets/weather_card.dart';
import 'package:iot_based_weather_station/widgets/custom_app_bar.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref();

    return Scaffold(
      backgroundColor: const Color(0xFF121221),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<DatabaseEvent>(
            stream: databaseReference.child('sensor').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white)));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return Center(
                    child: WeatherCard(
                        weatherData: WeatherData.fallback()));
              }

              final data = snapshot.data!.snapshot.value;

              if (data is Map) {
                final weatherData =
                    WeatherData.fromMap(data as Map<dynamic, dynamic>);
                if (weatherData.isValid()) {
                  return WeatherCard(weatherData: weatherData);
                } else {
                  return Center(
                      child: WeatherCard(
                          weatherData: WeatherData.fallback()));
                }
              } else {
                return Center(
                    child: WeatherCard(
                        weatherData: WeatherData.fallback()));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildFrostedBottomNavBar(),
    );
  }

   Widget _buildFrostedBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Blur effect
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black.withOpacity(0.12))
            ),
            child: const Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              //   Icon(Icons.home, color: Colors.white, size: 32),
              // ],
            ),
          ),
        ),
      ),
    );
  }
}