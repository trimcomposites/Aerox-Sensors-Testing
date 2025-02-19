import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_barrel.dart';

class LoginMainScreen extends StatelessWidget {
  const LoginMainScreen({super.key});

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
                LoginMainScreenContent(),
                if (state.uiState.status == UIStatus.loading) LoadingIndicator()
              ],
            ));
      },
    );
  }
}
