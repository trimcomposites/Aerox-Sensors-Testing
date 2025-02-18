import 'package:aerox_stage_1/features/feature_home/ui/widgets/bluetooth_connect_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/selected_racket_widget.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/details_screen.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_select/ui/racket_select_screen.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/top_notch_padding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (state.myRacket != null)
                    SelectedRacketWidget(racket: state.myRacket!),

                  Positioned(
                    bottom: 80, 
                    child: AppButton(
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
                  ),
                  BluetoothConnectButton()
                ],
              );
              },
            ),
          ),
        ),
      ),
    );
  }
}
