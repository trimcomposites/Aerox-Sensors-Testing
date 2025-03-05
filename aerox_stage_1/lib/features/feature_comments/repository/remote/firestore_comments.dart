import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/models/comment_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class FirestoreComments {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<EitherErr<void>> saveComment(Comment comment) async {
  return EitherCatch.catchAsync<void, CommentErr>(() async {
    try {
      DateTime now = DateTime.now();
      Map<String, dynamic> commentData = {
        'content': comment.content,
        'authorId': comment.authorId,
        'authorName': comment.authorName,
        'date': now.toIso8601String(),
        'location': comment.location,
        'racketId': comment.racketId,
        'racket': comment.racket,
        'hit': comment.hit,
        'isVisible': true,
        'id': comment.id
      };


       var docRef = await _firebaseFirestore.collection('comments').add(commentData);


      await docRef.update({
        'docId': docRef.id,
      });
      
    } catch (e) {
      throw CommentErr(
        errMsg: 'Error al publicar comentario: $e',
        statusCode: 500,
      );
    }
  }, (exception) {
    return CommentErr(
      errMsg: 'Error al publicar comentario: ${exception.toString()}',
      statusCode: 500,
    );
  });
}

Future<EitherErr<List<Comment>>> getCommentsByRacketId(String racketId) async {
  return EitherCatch.catchAsync<List<Comment>, CommentErr>(() async {
    final querySnapshot = await _firebaseFirestore
        .collection('comments')
        .where('racketId', isEqualTo: racketId)
        .where( 'isVisible', isEqualTo: true )
        .get();

    List<Comment> commentList = querySnapshot.docs.map((doc) {
      final comment = Comment();
      print(doc.id);
      return comment.fromFSComment(doc.data(  ), doc.id);
    }).toList();
    commentList.sort((a, b) {

      DateTime dateA = DateTime.parse(a.realDate!);
      DateTime dateB = DateTime.parse(b.realDate!);
      return dateB.compareTo(dateA); 
    });
    return commentList;
    }, (exception) => CommentErr(errMsg: 'Error al obtener comentarios: $exception', statusCode: 500));
  }

  Future<EitherErr<void>> hideComment( commentId) async {
  return EitherCatch.catchAsync<void, CommentErr>(() async {
    try {
      DocumentReference commentDocRef = _firebaseFirestore.collection('comments').doc(commentId);
      await commentDocRef.update({
        'isVisible': false,
      });

    } catch (e) {
      throw CommentErr(
        errMsg: 'Error al ocultar el comentario: $e',
        statusCode: 500,
      );
    }
  }, (exception) {
    return CommentErr(
      errMsg: 'Error al ocultar el comentario: ${exception.toString()}',
      statusCode: 500,
    );
  });
}

}