import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key, required this.racketId,
  });
  final int racketId;

  @override
  Widget build(BuildContext context) {
    final comments = FirestoreComments().getCommentsByRacketId(racketId );
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notas',
                style: TextStyle(fontSize: 30),
              ),
              AddCommentButton(),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream:  FirestoreComments().getCommentsByRacketId(racketId ), 
            builder: ( context, snapshot ) {
              if( snapshot.hasData ){
                var comments = snapshot.data!.docs;

                return ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var comment = comments[index];

                  return Comment(
                    authorName: comment['authorId'], // Asumiendo que 'authorId' es el nombre del autor
                    date: '11111', // Utilizamos la fecha proporcionada en el comentario
                    location: comment['location'], // Usamos la ubicación del comentario
                    content: comment['content'], // Contenido del comentario
                    time: '11', // Formateamos la fecha para mostrar el tiempo
                  );
                },
              );
            }
            return Container( child: Text( 'No hay comentarios' ), );
          }),
        ],
      ),
    );
  }
}
