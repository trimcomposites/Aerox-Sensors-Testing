import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/error_details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/loading_details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/racket_image.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_select/ui/racket_select_screen.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/top_notch_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

import 'home_page_barrel.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenBloc homeScreenBloc =
        BlocProvider.of<HomeScreenBloc>(context)..add(OnGetSelectedRacketHome());
    final RacketBloc racketBloc = BlocProvider.of<RacketBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    void onback() {
      homeScreenBloc.add(OnGetSelectedRacketHome());
      Navigator.of(context).pop();
      // Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList()));
    }

    return TopNotchPadding(
      color: Colors.white,
      context: context,
      child: Scaffold(
        appBar: HomePageAppbar(),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Column(
                          children: [
                            (state.myRacket != null)
                                ? SelectedRacketWidget()
                                : Container(),
                          ],
                        ),
                        AppButton(
                          text: 'CONFIGURA TU PALA',
                          fontColor: Colors.black,
                          backgroundColor: appYellowColor,
                          showborder: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => homeScreenBloc.state.myRacket != null
                                    ? DetailsScreen(onback: onback)
                                    : RacketSelectScreen(onback: onback),
                              ),
                            );
                          },
                        ),
                        // Text(
                        //   'raqueta seleccionada ${state.myRacket?.nombrePala}    '
                        //   'raquetas ${racketBloc.state.rackets.length}',
                        //   style: const TextStyle(color: Colors.black),
                        // ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedRacketWidget extends StatelessWidget {
  const SelectedRacketWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text( state.myRacket!.nombrePala, style: TextStyle( fontSize: 60 ), textAlign: TextAlign.center, ),
        RacketImage(
            isRacketSelected: true,
            racket: state.myRacket!,
          ),
      ],
    );
  }
}
