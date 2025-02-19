import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class LoginWithEmailScreen extends StatelessWidget {
  const LoginWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        userBloc.add(OnDeleteErrorMsg());
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: BackButtonAppBar(),
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  BackgroundGradient(),
                  LoginWithEmailContent(),
                  if (state.uiState.status == UIStatus.loading)
                    LoadingIndicator()
                ],
              ));
        },
      ),
    );
  }
}
