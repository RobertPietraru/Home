import 'package:testador/features/quiz/data/dtos/question/question_dto.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class SuggestOptionsUsecase
    extends UseCase<SuggestOptionsUsecaseResult, SuggestOptionsUsecaseParams> {
  const SuggestOptionsUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SuggestOptionsUsecaseResult>> call(params) async {
    return quizRepository.suggestOptions(params);
  }
}

class SuggestOptionsUsecaseParams extends Params {
  final DraftEntity draft;
  final int questionIndex;
  const SuggestOptionsUsecaseParams({
required this.questionIndex, 
    required this.draft,
  });
}

class SuggestOptionsUsecaseResult extends Response {
  final DraftEntity draft;

  const SuggestOptionsUsecaseResult({
    required this.draft,
  });
}
