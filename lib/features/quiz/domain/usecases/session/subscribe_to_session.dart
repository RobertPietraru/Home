import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class SubscribeToSessionUsecase extends UseCase<SubscribeToSessionUsecaseResult,
    SubscribeToSessionUsecaseParams> {
  const SubscribeToSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, SubscribeToSessionUsecaseResult>> call(
      params) async {
    return quizRepository.subscribeToSession(params);
  }
}

class SubscribeToSessionUsecaseParams extends Params {
  final String sessionId;
  const SubscribeToSessionUsecaseParams({required this.sessionId});
}

class SubscribeToSessionUsecaseResult extends Response {
  final Stream<SessionEntity> sessions;
  final SessionEntity currentSession;
  const SubscribeToSessionUsecaseResult({required this.sessions, required this.currentSession, });
}
