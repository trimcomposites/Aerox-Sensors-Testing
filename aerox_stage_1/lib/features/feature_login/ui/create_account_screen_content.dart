
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_login/blocs/user/user_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_message_text.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/login_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_barrel.dart';

class CreateAccountScreenContent extends StatelessWidget {
  CreateAccountScreenContent({
    super.key,
  });

  final formKey= GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  validateConfirmPassword(value) {
    if (value == null ||value.isEmpty) {
      return 'Confirm Password is required';
    }
      if (value != passwordController.text) {
        return 'Passwords do not match';
    }
      return null;
  }

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>( context );


    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 200,),
              LoginMessageText(text: 'Crear Cuenta'),
              // segunda seccion
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    DataContainer(
                      child: UserDataTextField(text: 'Nombre Completo', controller: nameController, validator: null, )
                    ),

                    const SizedBox(height: 30),

                    DataContainer(
                      child: UserDataTextField(  text: 'E-mail', controller: emailController, validator: null, )
                    ),
      
                    const SizedBox(height: 30),
      
                    DataContainer(
                      child: UserDataTextField( text: 'Contraseña', controller: passwordController, validator: null, obscureText: true)
                    ),
      
                    const SizedBox(height: 30),
                    //const SizedBox(height: 15),
                    // SizedBox(
                    //   width: 300,
                    //   height: 75,
                    //   child:  ConditionsCheckBox()          
                    // ),
                    AppButton(
                      backgroundColor: appYellowColor,
                      text: 'REGISTRAR',
                      fontColor: Colors.black,
                      showborder: false,
                      onPressed: (){

                        //userBloc.add( OnStartLoadingUser() );
                        userBloc.add( OnEmailRegisterUser(email: emailController.text, password: passwordController.text, name: nameController.text ) );

                      }
                    ),

                    SizedBox( height: 15, ),

                    LoginErrorMessage()
                  ],
                )
              ),
            ],
          ),
      ),
    );

    
  }
}
