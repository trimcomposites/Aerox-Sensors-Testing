import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_widget.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/with_menu_and_return_app_bar.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class FullCommentScreen extends StatelessWidget {
  const FullCommentScreen({super.key, required this.comment});
  final Comment comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WithMenuAndReturnAppBar(
        onback: () => Navigator.pop( context ),
      ),
      body: CommentWidget(
              fullScreen: true,
              comment: comment,
              authorName: comment.authorName ?? 'Anónimo',
              date: comment.date ?? 'No hay datos',
              location: comment.location ?? 'No hay datos',
              content: comment.content ?? 'No hay comentario',
              time: comment.time ?? 'Hace mucho',
          )
    );
  }
}