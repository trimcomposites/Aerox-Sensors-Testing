import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/feature_login/ui/login_barrel.dart';

void main() => runApp(
   MultiBlocProvider(
    providers: [
      BlocProvider(create: ( context ) => UserBloc( context )..add( OnCheckUserIsSignedIn() ) )
  ],
  child: const MyApp())
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerox',
      home: SplashScreen()
    );
  }
}