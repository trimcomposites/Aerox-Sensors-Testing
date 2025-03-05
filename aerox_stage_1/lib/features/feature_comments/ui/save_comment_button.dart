import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveCommentButton extends StatelessWidget {
  const SaveCommentButton({
    super.key,
    required this.textController,
    required this.user, 
    this.enabled = true
  });
  final TextEditingController textController;
  final AeroxUser user;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final commentsBloc = BlocProvider.of<CommentsBloc>(context);
    return Container(
        decoration: BoxDecoration(
          border: Border.all( color: Colors.transparent ),
          borderRadius: BorderRadius.circular(30),
          color: enabled
          ? appYellowColor
          : Colors.grey.shade700
      ),
        
      height: 50,
      width: 150,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: (){
          final comment = Comment( authorId: user.id,
                                    authorName: user.name,
                                    content: textController.text,
                                    location: commentsBloc.state.city,
                                    racketId: commentsBloc.state.racket!.docId,
                                    hit: commentsBloc.state.racket!.hit, 
                                    racket: commentsBloc.state.racket!.frame, 
                                );
          if(textController.text.isNotEmpty && enabled ){
            commentsBloc.add( OnSaveComment(comment: comment) );
          }

        },
        child: Center(child: Text('GUARDAR', style: TextStyle( fontWeight: FontWeight.bold ),))
      ),
    );
  }
}
