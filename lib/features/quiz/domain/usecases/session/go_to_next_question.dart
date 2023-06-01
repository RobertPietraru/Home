import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class GoToNextQuestionUsecase extends UseCase<GoToNextQuestionUsecaseResult,
    GoToNextQuestionUsecaseParams> {
  const GoToNextQuestionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, GoToNextQuestionUsecaseResult>> call(
      params) async {
    return quizRepository.goToNextQuestion(params);
  }
}

class GoToNextQuestionUsecaseParams extends Params {
  final SessionEntity session;
  final QuizEntity quiz;
  const GoToNextQuestionUsecaseParams(
      {required this.session, required this.quiz});
}

class GoToNextQuestionUsecaseResult extends Response {
  final SessionEntity session;
  const GoToNextQuestionUsecaseResult({required this.session});
}
