import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.5), // Semi-transparent black
            Colors.black.withOpacity(0.5), // Semi-transparent black (same color to extend)
            const Color.fromARGB(255, 66, 64, 64).withOpacity(0.5), // Semi-transparent white
          ],
          stops: const [0.0, 0.5, 1.0], // Adjust the stops for the gradient
        ),
      ),
    );
  }
}
