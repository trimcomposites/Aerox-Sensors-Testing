import 'package:aerox_stage_1/features/feature_comments/ui/comment.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_button.dart';

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
                style: TextStyle(fontSize: 30),
              ),
              AddCommentButton(),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Comment(
                authorName: 'Samuel',
                date: '08.02.25',
                location: 'Málaga',
                content: 'Excepteur ea consectetur et mollit mollit. Nulla eu deserunt laboris nostrud '
                  'culpa id do pariatur mollit aliquip excepteur proident reprehenderit in. Minim magna i'
                  'n pariatur dolore mollit sint pariatur. Labore eiusmod labore do exercitation amet nostrud consectetur occaecat e'
                  'xcepteur commodo reprehenderit. Lorem est consectetur dolore mollit nisi elit est occaecat fugiat. Voluptate sunt des'
                  'erunt cillum eiusmod veniam adipisicing.',
                time: 'Hoy',
              );
            },
          ),
        ],
      ),
    );
  }
}
