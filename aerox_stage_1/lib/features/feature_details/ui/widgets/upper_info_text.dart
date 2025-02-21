import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class UpperInfoText extends StatelessWidget {
  const UpperInfoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Este es el resultado de tu configuración, comprueba la ficha técnica y guarda o edita de nuevo.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black.withAlpha(128), 
        fontSize: 12,
      ),
      maxLines: 2,
    );
  }
}
