import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_connect_button.dart';
import 'package:aerox_stage_1/common/ui/selected_racket_widget.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageAdminView extends StatelessWidget {
  const HomePageAdminView({
    super.key,
    required this.homeScreenBloc,
    required this.onback
  });

  final HomeScreenBloc homeScreenBloc;
  final void Function()? onback;
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
    
              BluetoothConnectButton(
                position: 250,
              )
            ]
          );
          },
        ),
      ),
    );
  }
}
