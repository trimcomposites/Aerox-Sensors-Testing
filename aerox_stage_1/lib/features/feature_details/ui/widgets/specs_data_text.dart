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
    final statBarSize = MediaQuery.of(context).size.width/2.5;
    final fontSize = MediaQuery.of(context).size.width*0.043;
    final double numValue = ((value - min) / (max - min)) * statBarSize;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text, 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.black.withAlpha(128)
        ),),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: statBarSize,
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

