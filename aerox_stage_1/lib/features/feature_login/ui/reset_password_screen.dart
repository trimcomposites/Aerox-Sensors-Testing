import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/reset_password_screen_content.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                BackGroundImage(),
                BackgroundGradient(),
                ResetPasswordScreenContent(),
                if (state.uiState.status == UIStatus.loading) LoadingIndicator()
              ],
            ));
      },
    );
  }
}
