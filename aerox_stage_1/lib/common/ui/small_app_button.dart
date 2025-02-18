import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';

class SmallAppButton extends StatelessWidget {
  const SmallAppButton({
    super.key,
    required  this.text, 
    required this.onTap
  });
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    

      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: appYellowColor,
          ),
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10
            ),
            child: Text( 
              text, 
              style: TextStyle( 
              fontSize: 14
                ), 
              ),
          ),
          ),
      );
  }
}


