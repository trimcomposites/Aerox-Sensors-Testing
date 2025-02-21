import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class TechnicalSpecsText extends StatelessWidget {
  const TechnicalSpecsText({
    super.key, required this.title, required this.value,
  });
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: TextStyle(
            fontSize: 10
          ),
        ),
        SizedBox( height: 5, ),
        Text(
          value, 
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16
          ),
        )
      ],
    );
  }
}


     