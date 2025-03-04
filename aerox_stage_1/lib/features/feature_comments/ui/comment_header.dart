import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
    required this.authorName,
    required this.date,
    required this.location, 
    required this.fullScreen,
  });

  final String authorName;
  final String date;
  final String location;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        CircleAvatar(radius: 20),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 210,

                child: fullScreen
                ? Text(
                    authorName,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      authorName,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
    );
  }
}