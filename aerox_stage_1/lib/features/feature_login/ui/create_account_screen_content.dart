
import 'package:aerox_stage_1/features/feature_login/blocs/user/user_bloc.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
              child: Padding(
              padding: const EdgeInsets.only(
                left: 100.0, 
                right: 100,
                top: 150,
                bottom: 30
              ), // Adding padding around the image
              child: Image.asset('assets/Logotipo-Aerox-Blanco.png'), // Displaying an asset image
                ),
              ),
              const SizedBox(height: 30,),
              // segunda seccion
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DataContainer(
                      child: UserDataTextField( 'Email', text: 'E-mail', controller: emailController, validator: null, )
                    ),
      
                    const SizedBox(height: 30),
      
                    DataContainer(
                      child: UserDataTextField("Name", text: 'Nombre', controller: nameController, validator: null, )
                    ),
      
                    const SizedBox(height: 30),
      
                    DataContainer(
                      child: UserDataTextField("Password", text: 'Contraseña', controller: passwordController, validator: null, obscureText: true)
                    ),
      
                    const SizedBox(height: 30),
      
      
                    DataContainer(
                      child: UserDataTextField( "Confirm Password", 
                        text: 'Confirmar contraseña',
                        controller: confirmPasswordController, 
                        validator:( value ) => validateConfirmPassword(value),
                        obscureText: true
                      ),
                    ),
                    
                    //const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      height: 75,
                      child:  ConditionsCheckBox()          
                    ),
                    AppButton(
                      backgroundColor: appYellowColor,
                      text: 'Crear una Cuenta',
                      fontColor: Colors.black,
                      showborder: false,
                      onPressed: (){

                        userBloc.add( OnEmailRegisterUser(email: emailController.text, password: passwordController.text ) );

                      }
                    ),

                    SizedBox( height: 15, ),

                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return state.errorMessage != null
                        ? Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 40 ),
                          child: Text( state.errorMessage! ,style: TextStyle( color: Colors.white ),  ),
                        )
                        : Container();
                        },
                      )
                  ],
                )
              ),
            ],
          ),
      ),
    );

    
  }
}
