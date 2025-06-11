import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_selected_racket_page.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_admin.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomePageAdmin(),
  '/splash': (context) => SplashScreen(),
  '/home': (context) => const HomePageAdmin(),
  '/bluetooth' : (context) =>  BluetoothSelectedRacketPage(),
};