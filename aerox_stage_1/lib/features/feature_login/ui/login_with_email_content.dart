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

                AppButton(
                  text: 'Iniciar Sesión',
                  backgroundColor: appYellowColor,
                  fontColor: Colors.black,
                  showborder: false,
                  onPressed: () => {
                    if( emailController.text.length >6 && passwordController.text.length>=8  ){
                    userBloc.add(OnEmailSignInUser(
                        email: emailController.text,
                        password: passwordController.text))
                    }else if( emailController.text.isEmpty  || passwordController.text.isEmpty ){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text( 'Debe introducir los datos para iniciar Sesión' ))
                      )
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text( 'El E-Mail o Contraseña introducidas no son lo suficientemente largos.' ))
                      )
                    }

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
