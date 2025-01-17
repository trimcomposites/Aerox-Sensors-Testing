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