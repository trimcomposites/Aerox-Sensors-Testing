import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';



void main() {
  late FirestoreComments firestoreComments;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockDocSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocSnapshot = MockQueryDocumentSnapshot();

    firestoreComments = FirestoreComments(firebaseFirestore: mockFirestore);
  });

  final comment = Comment(id: '123', content: 'Nice!', authorId: 'user1');

  group('saveComment', () {
    test('returns Right when comment is saved successfully', () async {
      when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);
      when(() => mockCollection.add(any())).thenAnswer((_) async => mockDoc);
      when(() => mockDoc.id).thenReturn('123');
      when(() => mockDoc.update({'docId': '123'})).thenAnswer((_) async {});

      final result = await firestoreComments.saveComment(comment);

      expect(result.isRight(), true);
    });

test('returns Left when saving comment fails', () async {
  when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);

  when(() => mockCollection.add(any())).thenAnswer((_) async => throw Exception('failed'));

  final result = await firestoreComments.saveComment(comment);

  expect(result.isLeft(), true);
});

  });

  group('getCommentsByRacketId', () {
    test('returns Right with comment list', () async {
      when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);
      when(() => mockCollection.where('racketId', isEqualTo: any(named: 'isEqualTo')))
          .thenReturn(mockCollection);
      when(() => mockCollection.where('isVisible', isEqualTo: true)).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
      when(() => mockDocSnapshot.data()).thenReturn({
        'id': '1',
        'authorId': 'user',
        'content': 'Good',
        'date': DateTime.now().toIso8601String(),
        'isVisible': true,
      });
      when(() => mockDocSnapshot.id).thenReturn('1');

      final result = await firestoreComments.getCommentsByRacketId('1');

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).length, 1);
    });

    test('returns Left when fetching comments fails', () async {
      when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);
      when(() => mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')))
          .thenThrow(Exception('Firestore error'));

      final result = await firestoreComments.getCommentsByRacketId('1');

      expect(result.isLeft(), true);
    });
  });

  group('hideComment', () {
    test('returns Right when hiding is successful', () async {
      when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);
      when(() => mockCollection.doc('123')).thenReturn(mockDoc);
      when(() => mockDoc.update({'isVisible': false})).thenAnswer((_) async {});

      final result = await firestoreComments.hideComment('123');

      expect(result.isRight(), true);
    });

    test('returns Left when hiding comment fails', () async {
      when(() => mockFirestore.collection('comments')).thenReturn(mockCollection);
      when(() => mockCollection.doc('123')).thenReturn(mockDoc);
      when(() => mockDoc.update({'isVisible': false})).thenThrow(Exception('fail'));

      final result = await firestoreComments.hideComment('123');

      expect(result.isLeft(), true);
    });
  });
}
