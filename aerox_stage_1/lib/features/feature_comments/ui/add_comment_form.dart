import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_text_field.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/save_comment_button.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentForm extends StatelessWidget {
  const AddCommentForm({
    super.key,
    required this.user
  });
  final AeroxUser user;
  @override
  Widget build(BuildContext context) {

    final textController = TextEditingController();

    final commentsBloc = BlocProvider.of<CommentsBloc>(context)..add( OnGetCityLocation() );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all( width: 1, color: Colors.transparent ),
        color: Colors.black,
      ),
      height: 425,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric( vertical: 40,  horizontal: 40 ),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Añade nota', textAlign: TextAlign.start, style: TextStyle( fontSize: 30, color: Colors.white, ),),
                SizedBox( height: 20,),
                AddCommentTextField( textControlller: textController, ),
                SizedBox( height: 10, ),
                Padding(
                  padding: EdgeInsets.only( left: 175 ),
                  child: SaveCommentButton( textController: textController, user: user, ),
                ),
                SizedBox( height: 10, ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon( Icons.location_on_outlined, color: Colors.grey, ),

                        BlocBuilder<CommentsBloc, CommentsState>(
                          builder: (context, state) {
                            return Text( state.city ,style: TextStyle( color: Colors.grey ),);
                          },
                        )

                        
                      ],
                    ),

                    Spacer(),
                    Text( '02.01.24', style: TextStyle( color: Colors.grey ),),

                  ],
                ) 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
