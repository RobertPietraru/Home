import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class ShowQuestionResultsUsecase extends UseCase<
    ShowQuestionResultsUsecaseResult, ShowQuestionResultsUsecaseParams> {
  const ShowQuestionResultsUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, ShowQuestionResultsUsecaseResult>> call(
      params) async {
    return quizRepository.showQuestionResults(params);
  }
}

class ShowQuestionResultsUsecaseParams extends Params {
  final SessionEntity session;
  final QuizEntity quiz;

  const ShowQuestionResultsUsecaseParams({
    required this.quiz,
    required this.session,
  });
}

class ShowQuestionResultsUsecaseResult extends Response {
  final SessionEntity session;
  const ShowQuestionResultsUsecaseResult({required this.session});
}
