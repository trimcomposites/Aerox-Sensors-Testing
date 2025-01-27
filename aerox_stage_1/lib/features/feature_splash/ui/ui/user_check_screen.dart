
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCheckScreen extends StatelessWidget {
  const UserCheckScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
  final userBloc = BlocProvider.of<UserBloc>(context);
  print('usuario $userBloc.state.user');
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return userBloc.state.user==null
        ? LoginMainScreen()
        : LoginMainScreen();
      },
    );
  }
}