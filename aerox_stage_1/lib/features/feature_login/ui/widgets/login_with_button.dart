import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithButton extends StatelessWidget {
  const LoginWithButton({
    super.key,
   required this.asset,
   this.onPressed
  });
  final String asset;
  final void Function()? onPressed;
 @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration( 
          shape: BoxShape.circle,
          color: Colors.transparent, 
        ),
        child: IconButton(
          icon: Image.asset(asset), 
          onPressed: onPressed
        ),
      ),
    );
  }
}