import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/error_details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/loading_details_screen.dart';
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

    final HomeScreenBloc homeScreenBloc = BlocProvider.of( context )..add( OnGetSelectedRacketHome() );
    final RacketBloc racketBloc = BlocProvider.of( context );
    final userBloc = BlocProvider.of<UserBloc>( context );
    onback() {
      homeScreenBloc.add(OnGetSelectedRacketHome());
      Navigator.of(context).pop();
      //Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList()));

    }

      return TopNotchPadding(
        context: context,
        child: Scaffold(
            appBar: HomePageAppbar(),
            backgroundColor: backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<HomeScreenBloc, HomeScreenState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(
                              'raqueta seleccionada ${state.myRacket?.nombrePala}    '
                              'raquetas ${racketBloc.state.rackets.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
                    AppButton(
                        text: 'TU PALA AEROX',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      homeScreenBloc.state.myRacket != null
                                          ? DetailsScreen(
                                            onback: onback,
                                          )
                                          : RacketSelectScreen(
                                            onback: onback,
                                          )));
                        }),
                    const SizedBox(height: 30),
                    AppButton(text: 'TU JUEGO', onPressed: () {}),

                    const SizedBox(height: 30),

                    AppButton(
                      text: 'JUGAR',
                      backgroundColor: appYellowColor,
                      showborder: false,
                      fontColor: Colors.black,
                      onPressed: () {},
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
                ),
              ),
            )),
      );
  }
}
