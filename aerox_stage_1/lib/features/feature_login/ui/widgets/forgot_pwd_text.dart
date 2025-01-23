
import 'package:flutter/gestures.dart';

import '../login_barrel.dart';

class ForgotPwdText extends StatelessWidget {
  const ForgotPwdText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white), // Default text color
          children: [
            TextSpan(
              text: 'Forgot Password? ',
              style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextSpan(
              text: 'Reset Password',
              style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
                decoration: TextDecoration.underline
              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                TODO: Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                );
              },
            ),
          ],
        ),
    );
  }
}
