import '../../failures/quiz_failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/classes/usecase.dart';
import '../../repositories/quiz_repository.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

class DeleteQuestionUsecase
    extends UseCase<DeleteQuestionUsecaseResult, DeleteQuestionUsecaseParams> {
  const DeleteQuestionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, DeleteQuestionUsecaseResult>> call(params) async {
    return quizRepository.deleteQuestion(params);
  }
}

class DeleteQuestionUsecaseParams extends Params {
  final DraftEntity draft;
  final int index;
  const DeleteQuestionUsecaseParams({required this.draft, required this.index});
}

class DeleteQuestionUsecaseResult extends Response {
  final DraftEntity quizEntity;
  const DeleteQuestionUsecaseResult({required this.quizEntity});
}
