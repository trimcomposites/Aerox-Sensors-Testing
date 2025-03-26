import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late GetCityLocationUseCase getCityLocationUseCase;
  late CommentsRepository commentsRepository;

  setUp(() {
    commentsRepository = MockCommentsRepository();
    getCityLocationUseCase = GetCityLocationUseCase(commentsRepository: commentsRepository);
  });

  group('GetCityLocationUseCase', () {
    test('should return Right(String) when getting city location is successful', () async {
      const cityLocation = "New York";
      when(() => commentsRepository.getCityLocation())
          .thenAnswer((_) async => Right(cityLocation));

      final result = await getCityLocationUseCase();

      expect(result, equals(Right<Err, String>(cityLocation)));
      verify(() => commentsRepository.getCityLocation()).called(1);
    });

    test('should return Left(Err) when getting city location fails', () async {
      final error = CommentErr(errMsg: "Failed to get city location", statusCode: 500);
      when(() => commentsRepository.getCityLocation())
          .thenAnswer((_) async => Left(error));

      final result = await getCityLocationUseCase();

      expect(result, isA<Left<Err, String>>());
      verify(() => commentsRepository.getCityLocation()).called(1);
    });
  });
}
