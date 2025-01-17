import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      backgroundColor: Colors.blue, 
      body: Center(
        child: Image.asset('assets/your_logo.png'), // Aquí se coloca el logo o imagen
      ),
    );
  }
}