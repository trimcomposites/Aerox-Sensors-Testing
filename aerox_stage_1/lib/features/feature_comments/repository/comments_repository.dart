import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/comment.dart';

class CommentsRepository {
  final FirestoreComments firestoreComments;
  final CommentLocationService commentLocationService;

  CommentsRepository({
    required this.firestoreComments,
    required this.commentLocationService
  });

  Future<EitherErr<List<Comment>>> getCommentsByRacketId(String racketId) async {
    
    return await firestoreComments
      .getCommentsByRacketId(racketId);
  } 
  Future<EitherErr<void>> saveComment(Comment comment) async {

    return await firestoreComments.saveComment(comment);
  } 
  Future<EitherErr<String>> getCityLocation() async {

    return await commentLocationService.getCity();
  } 
  Future<EitherErr<void>> hideComment( Comment comment ) async {

    return await firestoreComments.hideComment( comment.id );
  } 

}
