import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/full_comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/full_comment_screen.dart';
import 'package:flutter/material.dart';

class CommentContent extends StatelessWidget {
  const CommentContent({
    super.key,
    required this.content,
    required this.comment, 
    required this.fullScreen
  });

  final Comment comment;
  final String content;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxLines = 6;
          final textPainter = TextPainter(
            text: TextSpan(text: content, style: TextStyle(fontSize: 16)),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(maxWidth: constraints.maxWidth);

          bool isOverflowing = textPainter.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fullScreen 
                ? Container(
                  height: MediaQuery.of(context).size.height/1.8,
                  child: SingleChildScrollView(
                      child: Text(
                        content,
                        softWrap: true,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                )
                : Text(
                    content,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 16),
                  ),

              if (isOverflowing && !fullScreen) 
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => FullCommentScreen(comment: comment))
                    );
                  },
                  child: Text(
                    'Ver más...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
