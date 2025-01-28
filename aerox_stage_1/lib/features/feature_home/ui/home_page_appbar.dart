import 'home_page_barrel.dart';

class HomePageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppbar({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 20,
      child: Image.asset( 'assets/Logotipo-Aerox-Blanco.png', 
     ));
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}