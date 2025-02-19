import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_comments/ui/add_comment_button.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notas',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              AddCommentButton()
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.red,
                height: 200,
                width: 100,
                child: Column(
                  children: [
                    CircleAvatar(),
                    Column(
                      children: [
                        Text( 'Samuel' ),
                        Row(
                          children: [
                            Text('Málga'),
                            Icon( Icons.location_on_outlined )
                          ],
                        )
                      ],
                    )
                    
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
