import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/ui/details_screen_view.dart';
import 'package:aerox_stage_1/features/feature_details/ui/error_details_screen.dart';
import 'package:aerox_stage_1/features/feature_details/ui/loading_details_screen.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/with_menu_and_return_app_bar.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_admin.dart';
import 'package:aerox_stage_1/features/feature_select/blocs/select_screen/select_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature_login/ui/login_barrel.dart';

class RacketSelectScreen extends StatelessWidget {
  const RacketSelectScreen({super.key, required this.onback});

  final void Function()? onback;

  @override
  Widget build(BuildContext context) {
    final selectScreenBloc = BlocProvider.of<SelectScreenBloc>( context )..add( OnGetRacketsSelect() );
    return BlocListener<SelectScreenBloc, SelectScreenState>(
      listener: (context, state) {
        if (state.uiState.next != null) {
          onback?.call();
        }
      },
      child: BlocBuilder<SelectScreenBloc, SelectScreenState>(
        builder: (context, state) {
          return Container(
              child: Scaffold(
            backgroundColor: Colors.white,
            appBar: WithMenuAndReturnAppBar(
              onback: onback,
            ),
            body: 
            state.uiState.status != UIStatus.loading && state.rackets.isNotEmpty
            ? DetailsScreenView(
              rackets: state.rackets,
              isLoading: false,
              onPressedSelectRacket: (racket) {
                selectScreenBloc.add(OnSelectRacketSelect(racket: racket));
              },
            )
            : Center(child: CircularProgressIndicator())
          ));
        },
      ),
    );
  }
}
