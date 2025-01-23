import 'dart:io';

import 'package:aerox_stage_1/features/feature_details/repository/ui/details_screen.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/login_with_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class LoginMainScreenContent extends StatelessWidget {
  LoginMainScreenContent({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>( context );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50), // Adding padding around the image
              child: Image.asset('assets/Logotipo-Aerox-Blanco.png'), // Displaying an asset image
            ),
          ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AppButton(
                backgroundColor: appYellowColor,
                  text: 'Crear una Cuenta',
                  fontColor: Colors.black,
                  showborder: false,
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                  );
                }
              ),

              const SizedBox(height: 30),

              AppButton( 
                text: 'Iniciar Sesión',
                backgroundColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWithEmailScreen()),
                );}   
              ),
              const SizedBox(height: 30),

              AppButton(  //temp
                text: 'DEtalles previsualización',
                backgroundColor: Colors.transparent,
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: ( context ) => DetailsScreen()
                    )
                  )
                ;}   
              ),
              const SizedBox(height: 30),

              Text(
                "OR LOG IN WITH",
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginWithButton( asset: 'assets/google_logo.png', ),
                  
                  if( Platform.isIOS )
                  LoginWithButton( asset: 'assets/apple_logo.png', ),
                ],
              ),

            ],
          )
      ],
    );
  }


}
