import 'package:aerox_stage_1/features/feature_login/ui/login_message_text.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/login_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class LoginWithEmailContent extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox( height: 200, ),
           LoginMessageText( text: 'Bienvenido',  ) ,
          // segunda seccion

            
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //const SizedBox(height: 30,),
                DataContainer(
                    child: UserDataTextField(
                  controller: emailController,
                  text: 'E-mail',
                )),
                const SizedBox(height: 30),
                DataContainer(
                    child: UserDataTextField(
                  controller: passwordController,
                  obscureText: true,
                  text: 'Contraseña',
                )),
                const SizedBox(height: 30),
                //TODO:
                AppButton(
                  text: 'Iniciar Sesión',
                  backgroundColor: appYellowColor,
                  fontColor: Colors.black,
                  showborder: false,
                  onPressed: () => {
                    userBloc.add(OnEmailSignInUser(
                        email: emailController.text,
                        password: passwordController.text))
                  },
                ),


                const SizedBox( height: 30, ),

                LoginErrorMessage()
              ],
            ),
          
        ],
      ),
    );
  }
}
