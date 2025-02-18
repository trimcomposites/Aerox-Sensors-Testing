import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';

class AppNavigationBarButton extends StatelessWidget {
  const AppNavigationBarButton({
    super.key, required this.text, required this.iconData, required this.isSelected,
  });

  final String text;
  final IconData iconData;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: (){},
        child: Container(
          color: 
          isSelected
          ? Colors.black.withAlpha(180)
          : Colors.transparent,
          width:115,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
        
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon( iconData, color: Colors.white,  size: 30, ),
              ),
              
              Text( text, style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10 ), )
            ],
          ),
        ),
      ),
    );
  }
}
