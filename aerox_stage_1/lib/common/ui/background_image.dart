import 'package:flutter/material.dart';

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0), // Adjust padding as needed
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