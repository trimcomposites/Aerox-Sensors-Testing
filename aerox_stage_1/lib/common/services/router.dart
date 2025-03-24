import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_selected_racket_page.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_admin.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_main_screen.dart';
import 'package:aerox_stage_1/features/feature_login/ui/reset_password_screen.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/feature_login/ui/user_check_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const UserCheckScreen(),
  '/splash': (context) => SplashScreen(),
  '/home': (context) => const HomePageAdmin(),
  '/login/main': (context) => const LoginMainScreen(),
  '/login/email': (context) => const LoginMainScreen(),
  '/login/register': (context) => const LoginMainScreen(),
  '/login/password': (context) => const ResetPasswordScreen(),
  '/bluetooth' : (context) => const BluetoothSelectedRacketPage(),
};