import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class CreateDraftUsecase
    extends UseCase<CreateDraftUsecaseResult, CreateDraftUsecaseParams> {
  const CreateDraftUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, CreateDraftUsecaseResult>> call(params) async {
    return quizRepository.createQuiz(params);
  }
}

class CreateDraftUsecaseParams extends Params {
  final String creatorId;
  const CreateDraftUsecaseParams({
    required this.creatorId,
  });
}

class CreateDraftUsecaseResult extends Response {
  final DraftEntity draft;
  const CreateDraftUsecaseResult({required this.draft});
}
