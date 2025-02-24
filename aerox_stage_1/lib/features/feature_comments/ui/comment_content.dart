import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class CommentContent extends StatelessWidget {
  const CommentContent({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      child: Text( content,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }
}