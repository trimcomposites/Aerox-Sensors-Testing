import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_text_field.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/save_comment_button.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class AddCommentForm extends StatelessWidget {
  const AddCommentForm({
    super.key,
    required this.user
  });
  final AeroxUser user;
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
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
                        FutureBuilder(
                          future: CommentLocationService.getCity(),
                          initialData: '',
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if( snapshot.hasData ){
                              return Text( snapshot.data ,style: TextStyle( color: Colors.grey ),);
                            }else{
                              return Container();
                            }
                          },
                        ),
                        
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
