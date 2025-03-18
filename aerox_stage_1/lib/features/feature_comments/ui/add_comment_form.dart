import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_text_field.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/additional_comment_form_info.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/save_comment_button.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentForm extends StatelessWidget {
  const AddCommentForm({super.key, required this.user, required this.textController});
  final AeroxUser user;
  final  TextEditingController textController;
  @override
  Widget build(BuildContext context) {


    final commentsBloc = BlocProvider.of<CommentsBloc>(context)
      ..add(OnGetCityLocation());

    return BlocListener<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.uistate.status == UIStatus.success) {
          commentsBloc.add(OnGetRacketComments(racketId: state.racket!.docId));
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only( 
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), 
            topRight: Radius.circular(30),
          ),
            border: Border.all(width: 1, color: Colors.transparent),
            color: Colors.black,
          ),
          height: 425,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Añade nota',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AddCommentTextField(
                      textControlller: textController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 175),
                      child: BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                          return state.uistate.status != UIStatus.loading
                          ? SaveCommentButton(
                            textController: textController,
                            user: user,
                          )
                          : SaveCommentButton(textController: textController, user: user, enabled: false,);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AdditionalCommentFormInfo()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
