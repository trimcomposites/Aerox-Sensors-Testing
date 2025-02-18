import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all( color: Colors.black, width: 1 ),
        borderRadius: BorderRadius.circular(30)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('ADD'),
          Icon( Icons.comment )
        ],
      ),
    );
  }
}
