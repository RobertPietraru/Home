import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class JoinSessionUsecase
    extends UseCase<JoinSessionUsecaseResult, JoinSessionUsecaseParams> {
  const JoinSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, JoinSessionUsecaseResult>> call(params) async {
    return quizRepository.joinSession(params);
  }
}

class JoinSessionUsecaseParams extends Params {
  final String userId;
  final String name;
  final String sessionId;
  const JoinSessionUsecaseParams(
      {required this.userId, required this.name, required this.sessionId});
}

class JoinSessionUsecaseResult extends Response {
  final SessionEntity session;
  const JoinSessionUsecaseResult({required this.session});
}
