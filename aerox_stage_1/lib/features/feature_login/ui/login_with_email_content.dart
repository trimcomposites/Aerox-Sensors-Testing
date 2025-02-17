import 'package:aerox_stage_1/features/feature_login/ui/login_message_text.dart';
import 'package:aerox_stage_1/features/feature_login/ui/with_services_login_buttons.dart';
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

                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return state.errorMessage != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 40 ),
                      child: Column(
                        children: [
                          Text( state.errorMessage! ,style: TextStyle( color: Colors.white ),  ),
                          SizedBox( height: 10, ),
                        ],
                      ),
                    )
                    : Container();
                  },
                ),

                WithServicesLoginButtons()
              ],
            ),
          )
        ],
      ),
    );
  }
}
