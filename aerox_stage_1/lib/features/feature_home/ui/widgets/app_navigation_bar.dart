import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:aerox_stage_1/features/feature_home/ui/widgets/app_navigation_bar_button.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 25,
        left: 10,
        right: 10
      ),  
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
              isSelected: true,
            ),
            AppNavigationBarButton(
              iconData: Icons.sports_tennis_rounded,
              text: 'MIS PALAS',
              isSelected: false,
            ),
            AppNavigationBarButton(
              iconData: Icons.person_outlined,
              text: 'PERFIL',
              isSelected: false,
            ),
          ],
        ),
      ),
            ),
    );
  }
}
