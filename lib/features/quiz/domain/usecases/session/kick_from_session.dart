import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class KickFromSessionUsecase extends UseCase<KickFromSessionUsecaseResult,
    KickFromSessionUsecaseParams> {
  const KickFromSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, KickFromSessionUsecaseResult>> call(params) async {
    return quizRepository.kickFromSession(params);
  }
}

class KickFromSessionUsecaseParams extends Params {
  final String sessionId;
  final String userId;
  const KickFromSessionUsecaseParams(
      {required this.sessionId, required this.userId});
}

class KickFromSessionUsecaseResult extends Response {
  final SessionEntity session;
  const KickFromSessionUsecaseResult({required this.session});
}
