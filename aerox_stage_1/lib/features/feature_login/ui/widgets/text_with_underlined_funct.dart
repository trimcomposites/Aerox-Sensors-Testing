
import 'package:flutter/gestures.dart';

import '../login_barrel.dart';

class TextWithUnderLinedFunct extends StatelessWidget {
  const TextWithUnderLinedFunct({
    super.key, required this.text, required this.underlineText, this.onTap,
  });

  final String text;
  final String underlineText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white), // Default text color
          children: [
            TextSpan(
              text: text,
              style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextSpan(
              text: underlineText,
              style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
                decoration: TextDecoration.underline
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap
            ),
          ],
        ),
    );
  }
}
