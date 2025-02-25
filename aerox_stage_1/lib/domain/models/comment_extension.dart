import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:intl/intl.dart';

extension CommentExtension on Comment{

    Comment  fromFSComment(Map<String, dynamic> data) {

      final date = formatDate( data['date'].toString() );
      final time = timeAgo( data['date'].toString() );
    
    return Comment(
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      content: data['content'] ?? '',
      location: data['location'] ?? '',
      date: date ?? '',
      time: time ?? '', 
      racketId: data['racketId'] ?? '', 
      realDate: data['date'],
      racket: data[ 'racket' ] ?? '',
      hit: data[ 'hit' ] ?? '',
    );
  }
  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd.MM.yyyy').format(dateTime);
    }
    String timeAgo(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Hace un minuto";
    } else if (difference.inMinutes < 60) {
      return "Hace ${difference.inMinutes} minutos";
    } else if (difference.inHours < 24) {
      return "Hace ${difference.inHours} horas";
    } else if (difference.inDays < 30) {
      return "Hace ${difference.inDays} días";
    } else {
      return "Hace más de un mes";
    }
  }


}