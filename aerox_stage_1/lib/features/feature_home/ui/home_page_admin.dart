import 'package:aerox_stage_1/features/feature_home/ui/top_notch_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_barrel.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>( context );

    return TopNotchPadding(
      context: context,
      child: Scaffold(
        appBar: HomePageAppbar(),
        backgroundColor: backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only( bottom: 40 ),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppButton( 
                      text: 'TU PALA AEROX', 
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
            
                      // AppButton(
                      //   text: "SIGN OUT",
                      //   onPressed: (){
                      //     userBloc.add( OnGoogleSignOutUser() );
                      //     userBloc.add( OnEmailSignOutUser() );
                      //   } 
                      // ),
                    ],
                ),
          ),
        )
        ),
    );
  }
}