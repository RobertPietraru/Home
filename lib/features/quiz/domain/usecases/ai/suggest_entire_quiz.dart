import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class SuggestEntireQuizUsecase
    extends UseCase<SuggestEntireQuizUsecaseResult, SuggestEntireQuizUsecaseParams> {
  const SuggestEntireQuizUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SuggestEntireQuizUsecaseResult>> call(params) async {
    return quizRepository.suggestEntireQuiz(params);
  }
}

class SuggestEntireQuizUsecaseParams extends Params {
  final String creatorId;
  const SuggestEntireQuizUsecaseParams({
    required this.creatorId,
  });
}

class SuggestEntireQuizUsecaseResult extends Response {
  final DraftEntity draft;
  const SuggestEntireQuizUsecaseResult({required this.draft});
}
