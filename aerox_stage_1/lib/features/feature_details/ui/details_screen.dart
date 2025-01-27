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
    return Container(
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: WithMenuAndReturnAppBar(),
          body: Stack(
            children: [
              BlocBuilder<RacketBloc, RacketState>(
                builder: (context, state) {
                  if( state.isLoading ){
                    return Container(); //add loading screen
                  }
                  else if( state.myRacket == null ){

                    return DetailsScreenView(
                      rackets: state.rackets,
                      isLoading: false,
                    );

                  }else if( state.myRacket != null ){
                    return DetailsScreenView(
                      rackets: [ state.myRacket! ],
                      isLoading: false,
                    );
                  }else return Text( 'Error' ); //add error screen
                }
              )
            ],
          )),
    );
  }
}
