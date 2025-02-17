import 'home_page_barrel.dart';

class HomePageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppbar({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 20,
      color: Colors.transparent,
      child: Image.asset( 'assets/Logotipo-Aerox-Negro.jpg', 
     ));
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}