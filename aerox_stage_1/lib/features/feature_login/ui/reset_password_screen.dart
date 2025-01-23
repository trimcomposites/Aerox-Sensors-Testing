import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/reset_password_screen_content.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          BackGroundImage(),
          BackgroundGradient(),
          ResetPasswordScreenContent(),
        ],
      )
    );
  }
}
