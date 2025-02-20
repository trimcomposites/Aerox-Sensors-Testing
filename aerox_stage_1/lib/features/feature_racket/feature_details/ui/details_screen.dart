import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/details_screen_view.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/widgets/with_menu_and_return_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../feature_login/ui/login_barrel.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.onback});
  final void Function()? onback;

  @override
  Widget build(BuildContext context) {
    final racketBloc = BlocProvider.of<RacketBloc>(context);
    return BlocListener<RacketBloc, RacketState>(
      listener: (context, state) {
        if( state.uiState.next!=null ){
          //Navigator.pushReplacementNamed(context, state.uiState.next!);
        }
      },
      child: Container(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: WithMenuAndReturnAppBar(
                onback: onback,
              ),
              body: DetailsScreenView(
                  rackets: [racketBloc.state.myRacket!],
                  isLoading: false,
                  onPressedDeselectRacket: () {
                    racketBloc.add(
                      OnDeselectRacket(),
                      
                    );
                    onback?.call();
                  }))),
    );
  }
}
