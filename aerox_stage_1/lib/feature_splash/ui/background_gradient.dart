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
            Colors.black.withValues(alpha: 0.5), // Usando withValues en lugar de withOpacity
            Colors.black.withValues(alpha: 0.5), // Usando withValues en lugar de withOpacity
            const Color.fromARGB(255, 66, 64, 64).withValues(alpha: 0.5), // Usando withValues en lugar de withOpacity
          ],
          stops: const [0.0, 0.5, 1.0], // Adjust the stops for the gradient
        ),
      ),
    );
  }
}
