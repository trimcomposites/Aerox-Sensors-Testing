
import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/blob_database_page.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/app_navigation_bar.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/top_notch_padding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page_barrel.dart';


class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});



  @override
  Widget build(BuildContext context) {
    final HomeScreenBloc homeScreenBloc =
        BlocProvider.of<HomeScreenBloc>(context);
    void onback() {
      Navigator.of(context).pop();
    }
  
    return TopNotchPadding(
      color: Colors.white,
      context: context,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: HomePageAppbar(),
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            switch (state.selectedTab) {
              case HomeTab.home:
                return HomePageAdminView(homeScreenBloc: homeScreenBloc, onback: onback);
              case HomeTab.database:
                return BlobDatabasePage(); // tu vista de base de datos
            }
          },
        ),

        bottomNavigationBar: AppNavigationBar(),
      ),
    );
  }
}