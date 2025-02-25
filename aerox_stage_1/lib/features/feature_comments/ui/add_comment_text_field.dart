import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class AddCommentTextField extends StatelessWidget {
  const AddCommentTextField({
    super.key,
    required this.textControlller
  });
  final TextEditingController textControlller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all( color: Colors.white ),
        borderRadius: BorderRadius.circular(20)
      ),
      height: 180,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          controller: textControlller,
          maxLines: 6,
          minLines: 1,                   
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white ),
          decoration: InputDecoration(
             border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none, 
            disabledBorder: InputBorder.none, 
          ),
        ),
      ),
    );
  }
}
