import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class LoginMessageText extends StatelessWidget {
  const LoginMessageText({
    super.key, required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 20),
      child: Text( 
           text, 
           textAlign: TextAlign.start,
           style: TextStyle(
             color: Colors.white,
             fontSize: 30,
           ), ),
    );
  }
}
