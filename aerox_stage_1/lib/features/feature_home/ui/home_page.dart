import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

import 'home_page_barrel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          BackgroundGradient(),
          HomePageAdmin(),
        ],
      ),
    );
  }
}