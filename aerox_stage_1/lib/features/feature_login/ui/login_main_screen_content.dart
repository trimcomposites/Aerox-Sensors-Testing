import 'dart:io';

import 'package:aerox_stage_1/features/feature_login/ui/with_services_login_buttons.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/details_screen.dart';
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


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox( height: 150, ),
         Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 50), // Adding padding around the image
              child: Image.asset('assets/Logotipo-Aerox-Blanco.png'), // Displaying an asset image
            ),
          ),
         SizedBox(height: 20,), 
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                backgroundColor: appYellowColor,
                  text: 'REGíSTRATE',
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
                text: 'LOG IN',
                backgroundColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWithEmailScreen()),
                );}   
              ),
              const SizedBox(height: 30),

              WithServicesLoginButtons(),
              
            ],
          )
      ],
    );
  }


}
