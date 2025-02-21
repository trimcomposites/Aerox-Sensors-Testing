import 'package:aerox_stage_1/features/feature_comments/ui/comment_content.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_header.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

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
          CommentHeader(authorName: authorName, date: date, location: location),
          SizedBox(height: 10), 
          CommentContent(content: content),
        ],
      ),
    );
  }
}
