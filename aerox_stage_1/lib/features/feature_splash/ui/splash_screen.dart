
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_background_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();

  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    if(mounted){
      Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (context) => UserCheckScreen()), 
    );
    }
    
    //dispose();
  }

  @override
  Widget build(BuildContext context) {
        _navigateToHome();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BackgroundGradient(),
          Center(child: Padding(
            padding: const EdgeInsets.symmetric( horizontal: 60.0),
            child: Container(
              height: 30,
              child: Image.asset( 'assets/Logotipo-Aerox-Blanco.png',  fit: BoxFit.fill, )
            ),
          ))
        ],
      )
    );
  }
}