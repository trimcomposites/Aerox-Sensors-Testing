import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithButton extends StatelessWidget {
  const LoginWithButton({
    super.key,
   required this.asset,
  });
  final String asset;

 @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all( // ✅ Agrega un borde blanco
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration( // ✅ Asegura que el fondo del botón respete el borde
          shape: BoxShape.circle,
          color: Colors.transparent, 
        ),
        child: IconButton(
          icon: Image.asset(asset), // Icono personalizado
          onPressed: () {
            userBloc.add(OnGoogleSignInUser());
          },
        ),
      ),
    );
  }
}