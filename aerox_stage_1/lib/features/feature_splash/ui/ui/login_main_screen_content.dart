import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginMainScreenContent extends StatelessWidget {
  LoginMainScreenContent({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>( context );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50), // Adding padding around the image
              child: Image.asset('assets/Logotipo-Aerox-Blanco.png'), // Displaying an asset image
            ),
          ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AppButton(
                backgroundColor: appYellowColor,
                  text: 'Crear una Cuenta',
                  fontColor: Colors.black,
                  showborder: false,
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                  );
                }
              ),

              const SizedBox(height: 30),

              AppButton( 
                text: 'Iniciar Sesión',
                backgroundColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWithEmailScreen()),
                );}   
              ),
              const SizedBox(height: 30),

              Text(
                "OR LOG IN WITH",
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LoginWithButton( asset: 'assets/google_logo.png', ),
            ],
          )
      ],
    );
  }


}
