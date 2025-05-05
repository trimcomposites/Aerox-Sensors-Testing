import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/app_navigation_bar_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);

    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 25, left: 15, right: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppNavigationBarButton(
                    iconData: Icons.home_outlined,
                    text: 'HOME',
                    isSelected: state.selectedTab == HomeTab.home,
                    onTap: () {
                      homeScreenBloc.add(OnChangeHomeTab(HomeTab.home));
                    },
                  ),
                  AppNavigationBarButton(
                    iconData: Icons.sports_tennis_rounded,
                    text: 'BASE DE DATOS',
                    isSelected: state.selectedTab == HomeTab.database,
                    onTap: () {
                      homeScreenBloc.add(OnChangeHomeTab(HomeTab.database));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
