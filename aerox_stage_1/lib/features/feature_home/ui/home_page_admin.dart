import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_barrel.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton( 
              text: 'PALAS AEROX', 
              onPressed: () {
                // Navigator.push(
                // context,
                // MaterialPageRoute(builder: (context) => const CatalogScreen()),
                // );
              },
              ),
              const SizedBox(height: 30),
              AppButton( text: 'TU JUEGO',
                onPressed:() {

                }
              ),

              const SizedBox(height: 30),

              AppButton(
                text: 'JUGAR',
                backgroundColor: appYellowColor,
                showborder: false,
                fontColor: Colors.black,
                onPressed: (){
                },
              ),

              const SizedBox(height: 30),

              AppButton(
                text: "SIGN OUT",
                onPressed: (){
                  userBloc.add( OnGoogleSignOutUser() );
                  userBloc.add( OnEmailSignOutUser() );
                } 
              ),
            ],
        )
      ]
    );
  }
}