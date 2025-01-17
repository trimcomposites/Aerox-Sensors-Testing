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
    this.width = 300, 
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
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: TextButton(
        style: OutlinedButton.styleFrom(
          side: 
          showborder
          ? const BorderSide( 
            color: Colors.white,
            width: 2.0,
          )
          : null,
        ),
        onPressed: onPressed,
        child: Text(
          
          text,
          style: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(
          color: fontColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
          ),
          ),
        ),
      ),
    );
  }
}
