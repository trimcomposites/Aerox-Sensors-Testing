import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/ui/details_screen_view.dart';
import 'package:aerox_stage_1/features/feature_details/ui/with_menu_and_return_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature_login/ui/login_barrel.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final racketBloc = BlocProvider.of<RacketBloc>( context );
    return Container(
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: WithMenuAndReturnAppBar(),
          body: Stack(
            children: [
              BlocBuilder<DetailsScreenBloc, DetailsScreenState>(
                builder: (context, detailsScreenState) {
              return BlocBuilder<RacketBloc, RacketState>(
                builder: (context, racketState) {
                  if( detailsScreenState.isLoading ){
                    return Container(); //add loading screen
                  }
                  else if( racketState.myRacket == null ){

                    return DetailsScreenView(
                      rackets: racketState.rackets,
                      isLoading: false,
                      onPressedSelectRacket: ( racket ) => racketBloc.add( OnSelectRacket(racket: racket) ),
                    );

                  }else if( racketState.myRacket != null ){
                    return DetailsScreenView(
                      rackets: [ racketState.myRacket! ],
                      isLoading: false,
                      onPressedDeselectRacket: ()=> racketBloc.add( OnDeselectRacket( ),
                      )
                    );
                  }else return Text( 'Error' ); //add error screen
                }
              );
              }
            )
            ],
          )),
    );
  }
}
