import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_widget.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FakeLoadingCommentList extends StatelessWidget {
  const FakeLoadingCommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true, 
        physics: NeverScrollableScrollPhysics(), 
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
      
          return CommentWidget(
            fullScreen: false,
            comment: Comment(),
            authorName: 'Anónimo',
            date: 'No hay datos',
            location: 'No hay datos',
            content: 'No hay comentarioNo hay comentarioNo hay comentarioNo hay comentarioNo hay comentarioNo hay comentario'
                     'No hay comentario No hay comentarioNo hay comentarioNo hay comentarioNo hay comentarioNo hay comentario'
                     'No hay comentario No hay comentarioNo hay comentarioNo hay comentarioNo hay comentarioNo hay comentario'
                     'No hay comentario No hay comentarioNo hay comentarioNo hay comentarioNo hay comentarioNo hay comentario',
            time: 'Hace mucho',
          );
        }),
    );
  }
}