
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_form.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    super.key,
    required this.user
  });

  final AeroxUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all( color: Colors.black, width: 1 ),
        borderRadius: BorderRadius.circular(30)
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          showMaterialModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => AddCommentForm(),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('ADD'),
            Icon( Icons.comment ),
          ],
        ),
      ),
    );
  }
}
