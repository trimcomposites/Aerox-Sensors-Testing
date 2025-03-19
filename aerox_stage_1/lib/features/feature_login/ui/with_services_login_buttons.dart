import 'dart:io';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/login_with_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithServicesLoginButtons extends StatelessWidget {
  const WithServicesLoginButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    return Column(
      children: [
        Text(
          "CONECTA",
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginWithButton( 
              asset: 'assets/google_logo.png', 
              onPressed: () {
                userBloc.add( OnGoogleSignInUser() );
              },
              ),
            
            if( Platform.isIOS )
            LoginWithButton( 
              asset: 'assets/apple_logo.png', 
              onPressed: () {
                userBloc.add( OnAppleSignInUser() );
              },
            ),
          ],
        ),
    
      ],
    );
  }
}
