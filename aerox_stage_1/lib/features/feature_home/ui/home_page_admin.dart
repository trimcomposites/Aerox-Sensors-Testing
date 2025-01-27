import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/ui/details_screen.dart';
import 'package:aerox_stage_1/features/feature_details/ui/error_details_screen.dart';
import 'package:aerox_stage_1/features/feature_details/ui/loading_details_screen.dart';
import 'package:aerox_stage_1/features/feature_details/ui/racket_select_screen.dart';
import 'package:aerox_stage_1/features/feature_home/ui/top_notch_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_barrel.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {

    final detailsScreenBloc = BlocProvider.of<DetailsScreenBloc>( context );
    

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
                    BlocBuilder<RacketBloc, RacketState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text( 'raqueta seleccionada ${state.myRacket?.name}', style: TextStyle( color: Colors.white ), ),
                            Text( 'catalogo actual seleccionada ${state.rackets?.length}', style: TextStyle( color: Colors.white ), ),
                          ],
                        );
                      },
                    ),
                    AppButton( 
                      text: 'TU PALA AEROX', 
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return BlocBuilder<DetailsScreenBloc, DetailsScreenState>(
                            builder: (context, state) {
                              state is LoadingDetailsScreenState
                              
                              ? DetailsScreen()
                              : RacketSelectScreen();
                              return ErrorDetailsScreen();
                            },
                          );
                        }),
                       );
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