import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class LoginWithEmailScreen extends StatelessWidget {
  const LoginWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>( context );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        userBloc.add( OnDeleteErrorMsg() );
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BackButtonAppBar(),
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            BackgroundGradient(),
            LoginWithEmailContent()
          ],
        )
      ),
    );
  }
}

