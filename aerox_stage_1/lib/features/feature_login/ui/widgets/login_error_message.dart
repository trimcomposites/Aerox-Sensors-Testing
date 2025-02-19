import 'package:aerox_stage_1/features/feature_login/blocs/user/user_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginErrorMessage extends StatelessWidget {
  const LoginErrorMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String errorMsg = '';
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final errorMsg = state.uiState.errorMessage;
        return Padding(
          padding: const EdgeInsets.symmetric( horizontal: 40 ),
          child: Text(errorMsg, style: TextStyle( color: Colors.white ),),
        );
      },
    );
  }
}
