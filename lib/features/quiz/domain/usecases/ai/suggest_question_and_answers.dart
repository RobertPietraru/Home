import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class SuggestQuestionAndOptionsUsecase extends UseCase<
    SuggestQuestionAndOptionsUsecaseResult,
    SuggestQuestionAndOptionsUsecaseParams> {
  const SuggestQuestionAndOptionsUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SuggestQuestionAndOptionsUsecaseResult>> call(
      params) async {
    return quizRepository.suggestQuestionAndOptions(params);
  }
}

class SuggestQuestionAndOptionsUsecaseParams extends Params {
  final String creatorId;
  const SuggestQuestionAndOptionsUsecaseParams({
    required this.creatorId,
  });
}

class SuggestQuestionAndOptionsUsecaseResult extends Response {
  final DraftEntity draft;
  const SuggestQuestionAndOptionsUsecaseResult({required this.draft});
}
