import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class SpecsDataText extends StatelessWidget {
  const SpecsDataText({
    super.key, required this.text, required this.value, required this.min, required this.max,
  });
  final String text;
  final double value;
  final double min;
  final double max;
  @override
  Widget build(BuildContext context) {
    final double numValue = ((value - min) / (max - min)) * 120;
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

