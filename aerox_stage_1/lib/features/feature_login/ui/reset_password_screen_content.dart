import 'package:aerox_stage_1/features/feature_login/ui/widgets/login_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class ResetPasswordScreenContent extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 100.0,
                  right: 100,
                  top: 200,
                  bottom: 100), // Adding padding around the image
              child: Image.asset(
                  'assets/Logotipo-Aerox-Blanco.png'), // Displaying an asset image
            ),
          ),
          // segunda seccion
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if( userBloc.state.user != null ){
                Navigator.pushReplacement(
                 context,
                  MaterialPageRoute(builder: (context) => UserCheckScreen()),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //const SizedBox(height: 30,),
                DataContainer(
                    child: UserDataTextField(
                  'Email',
                  controller: emailController,
                  text: 'E-mail',
                )),
                const SizedBox(height: 30),
                //TODO:
                AppButton(
                  text: 'Cambiar Contraseña',
                  backgroundColor: Colors.transparent,
                  onPressed: () => 
                    userBloc.add(OnPasswordReset(
                      email: emailController.text,
                    )
                  )
                ),
                const SizedBox(height: 30),

                TextWithUnderLinedFunct(
                  text: 'Para iniciar sesión',
                  underlineText: 'pulsa aquí.',
                  onTap: (){
                    userBloc.add( OnDeleteErrorMsg() );
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginWithEmailScreen()),
                  );
                  }
                ),

                const SizedBox( height: 30, ),

                LoginErrorMessage()
              ],
            ),
          )
        ],
      ),
    );
  }
}
