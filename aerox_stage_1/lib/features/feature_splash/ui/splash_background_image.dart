import 'package:flutter/material.dart';

class SplashBackGroundImage extends StatelessWidget {
  const SplashBackGroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0), // Adjust padding as needed
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Pala-Catalogo.png'),
              fit: BoxFit.cover, // Adjust fit as needed
            ),
          ),
        ),
      ),
    );
  }
}