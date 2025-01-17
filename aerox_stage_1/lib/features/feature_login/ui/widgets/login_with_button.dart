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

      final UserBloc userBloc = BlocProvider.of<UserBloc>( context );

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Background color of the button
      ),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton( 
          icon: Image.asset( asset ), // Replace with your desired icon
          //color: Colors.black, // Icon color
          onPressed: (){
            userBloc.add( OnGoogleSignInUser() );
          }
        ),
      ),
    );
  }
}
