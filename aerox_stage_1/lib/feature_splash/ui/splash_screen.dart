import 'package:aerox_stage_1/feature_splash/ui/background_gradient.dart';
import 'package:aerox_stage_1/feature_splash/ui/resources.dart';
import 'package:aerox_stage_1/feature_splash/ui/splash_background_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()), 
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SplashBackGroundImage(),
          BackgroundGradient(),
          Center(child: Padding(
            padding: const EdgeInsets.symmetric( horizontal: 80.0),
            child: Image.asset( 'assets/Logotipo-Aerox-Blanco.png' ),
          ))
        ],
      )
    );
  }
}