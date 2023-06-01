import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import '../../failures/quiz_failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/classes/usecase.dart';
import '../../repositories/quiz_repository.dart';

class SyncQuizUsecase
    extends UseCase<SyncQuizUsecaseResult, SyncQuizUsecaseParams> {
  const SyncQuizUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SyncQuizUsecaseResult>> call(params) async {
    return quizRepository.syncQuiz(params);
  }
}

class SyncQuizUsecaseParams extends Params {
  final DraftEntity draft;
  const SyncQuizUsecaseParams({required this.draft});
}

class SyncQuizUsecaseResult extends Response {
  const SyncQuizUsecaseResult();
}
