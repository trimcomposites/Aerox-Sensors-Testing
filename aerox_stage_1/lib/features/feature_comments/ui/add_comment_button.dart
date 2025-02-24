import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
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
      child: InkWell(
        onTap: () {
          final comments = FirestoreComments();
          //TODO: PAgina de comentar
          comments.publishComment(content: 'Contenido del comentario', userId: 'dffd', location: 'Madrid', racketId: '1');
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
