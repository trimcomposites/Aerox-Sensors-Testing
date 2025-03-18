import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key, 
    required this.onPressed, 
    required this.text, 
    this.backgroundColor = Colors.transparent, 
    this.fontColor = Colors.white, 
    this.showborder = true, 
    this.width = 325, 
    this.height = 75,
  });
  final void Function() onPressed;
  final String text;
  final Color backgroundColor;
  final Color fontColor;
  final bool showborder;
  final double width;
  final double height;
  
@override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15), // Asegura que el fondo respete los bordes
    child: Container(
      width: width,
      height: height,
      color: backgroundColor, 
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: showborder
              ? const BorderSide(color: Colors.white, width: 2.0)
              : BorderSide.none,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: fontColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
}