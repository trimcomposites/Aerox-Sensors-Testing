import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
    required this.authorName,
    required this.date,
    required this.location,
  });

  final String authorName;
  final String date;
  final String location;

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
    );
  }
}