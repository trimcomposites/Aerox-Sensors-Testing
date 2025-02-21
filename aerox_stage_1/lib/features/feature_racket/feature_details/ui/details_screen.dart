import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
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
    final detailsScreenBloc = BlocProvider.of<DetailsScreenBloc>(context)
      ..add(OnGetSelectedRacketDetails());
    return Container(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: WithMenuAndReturnAppBar(
              onback: onback,
            ),
            body: BlocBuilder<DetailsScreenBloc, DetailsScreenState>(
              builder: (context, state) {
                return 
                state.uiState.status != UIStatus.loading && state.racket!= null
                ? DetailsScreenView(
                    rackets: [detailsScreenBloc.state.racket!],
                    isLoading: false,
                    onPressedDeselectRacket: () {
                      detailsScreenBloc.add(
                        OnUnSelectRacketDetails(),
                      );
                      onback?.call();
                    })
                    : CircularProgressIndicator();
              },
            )));
  }
}
