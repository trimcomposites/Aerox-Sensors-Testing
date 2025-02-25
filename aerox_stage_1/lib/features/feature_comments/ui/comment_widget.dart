import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_content.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_header.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.authorName,
    required this.date,
    required this.location,
    required this.content,
    required this.time,
    required this.comment,
    required this.fullScreen
  });
  final String date;
  final String location;
  final String authorName;
  final String content;
  final String time;
  final Comment comment;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time),
              //Text(comment.id ?? 'no hay id'),
              IconButton(
                onPressed: (){
                  final commentsBloc = BlocProvider.of<CommentsBloc>(context);
                  commentsBloc.add( OnHideComment(comment: comment) );
                  commentsBloc.add( OnGetSelectedRacketComments());
                },
                icon: Icon( Icons.delete, size: 20, color: Colors.red,  )
              )
            ],
          ),

          SizedBox( height: 15, ),
          CommentHeader( fullScreen: fullScreen, authorName: authorName, date: date, location: location),
          SizedBox(height: 10), 
          CommentContent(  fullScreen: fullScreen, comment: comment, content: content),
        ],
      ),
    );
  }
}
