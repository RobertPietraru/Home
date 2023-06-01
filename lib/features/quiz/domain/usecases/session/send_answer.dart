import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class SendAnswerUsecase
    extends UseCase<SendAnswerUsecaseResult, SendAnswerUsecaseParams> {
  const SendAnswerUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SendAnswerUsecaseResult>> call(params) async {
    return quizRepository.sendAnswer(params);
  }
}

class SendAnswerUsecaseParams extends Params {
  final String sessionId;
  final String userId;
  final List<int>? answerIndexes;
  final String? answer;
  final Duration responseTime;

  const SendAnswerUsecaseParams(
      {required this.sessionId,
      required this.userId,
      required this.responseTime,
      this.answerIndexes,
      this.answer});
}

class SendAnswerUsecaseResult extends Response {
  final SessionEntity session;
  const SendAnswerUsecaseResult({required this.session});
}
