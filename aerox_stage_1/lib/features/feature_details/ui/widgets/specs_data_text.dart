import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class SpecsDataText extends StatelessWidget {
  const SpecsDataText({
    super.key, required this.text, required this.value,
  });
  final String text;
  final double value;
  @override
  Widget build(BuildContext context) {
    final double numValue =value/4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text, 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 23,
          color: Colors.black.withAlpha(128)
        ),),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: 120,
              height: 3,
              color: Colors.black,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              width: numValue,
              height: 8,
            ),
            
          ],
        )
        
      ],
    );
  }
}

