import 'package:google_fonts/google_fonts.dart';

import 'login_barrel.dart';

class LoginMainScreen extends StatelessWidget {
  const LoginMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          BackGroundImage(),
          BackgroundGradient(),
          LoginMainScreenContent(),
        ],
      )
    );
  }
}
