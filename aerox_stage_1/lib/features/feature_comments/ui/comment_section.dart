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

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.authorName,
    required this.date,
    required this.location,
    required this.content,
    required this.time
  });
  final String date;
  final String location;
  final String authorName;
  final String content;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(time),
          SizedBox( height: 15, ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              CircleAvatar(radius: 20),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(date),
                      SizedBox(width: 5),
                      Icon(Icons.location_on_outlined, size: 16),
                      SizedBox(width: 5),
                      Text( location ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10), 
          Container(
            width: double.infinity, 
            child: Text( content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
