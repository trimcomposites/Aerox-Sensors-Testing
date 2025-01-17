
import 'package:aerox_stage_1/features/feature_home/ui/home_page_admin.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class UserCheckScreen extends StatelessWidget {
  const UserCheckScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
  final userBloc = BlocProvider.of<UserBloc>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return userBloc.state.user==null
        ? LoginMainScreen()
        : HomePageAdmin();
      },
    );
  }
}