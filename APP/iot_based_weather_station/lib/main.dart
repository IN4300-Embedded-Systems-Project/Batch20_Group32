
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot_based_weather_station/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home:
          const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}