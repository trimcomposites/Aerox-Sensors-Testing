import 'package:aerox_stage_1/feature_splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerox',
      home: SplashScreen()
    );
  }
}