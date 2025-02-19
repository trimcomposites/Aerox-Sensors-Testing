import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user/user_bloc.dart';
import 'login_barrel.dart';
import 'user_check_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        userBloc.add(OnDeleteErrorMsg());
      },
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (userBloc.state.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserCheckScreen()),
            );
          }
        },
      
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: backgroundColor,
          appBar: BackButtonAppBar( () => Navigator.pop( context ) ),
          body: Stack(
            children: [
              BackgroundGradient(),
              CreateAccountScreenContent(),
            ],
          ),
        ),
      ),
    );
  }
}
