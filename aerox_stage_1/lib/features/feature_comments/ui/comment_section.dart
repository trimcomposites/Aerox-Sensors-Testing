import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/fake_loading_comment_list.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key, required this.racketId,
  });
  final int racketId;

  @override
  Widget build(BuildContext context) {
    final commentsBloc = BlocProvider.of<CommentsBloc>(context)
      ..add(OnGetRacketComments(racketId: racketId))
      ..add(OnGetCurrentUser())
      ..add(OnGetSelectedRacketComments());

    return SingleChildScrollView(
      child: BlocBuilder<CommentsBloc, CommentsState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notas',
                    style: TextStyle(fontSize: 30),
                  ),
                  commentsBloc.state.user != null
                      ? AddCommentButton(user: commentsBloc.state.user!)
                      : Container(),
                ],
              ),
              state.uistate.status != UIStatus.loading
              ? ListView.builder(
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(), 
                itemCount: state.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  var comment = state.comments[index];

                  return CommentWidget(
                    authorName: comment.authorName ?? 'Anónimo',
                    date: comment.date ?? 'No hay datos',
                    location: comment.location ?? 'No hay datos',
                    content: comment.content ?? 'No hay comentario',
                    time: comment.time ?? 'Hace mucho',
                  );
                },
              )
              : FakeLoadingCommentList()
            ],
          );
        },
      ),
    );
  }
}

