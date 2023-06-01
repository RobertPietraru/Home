import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class LeaveSessionUsecase
    extends UseCase<LeaveSessionUsecaseResult, LeaveSessionUsecaseParams> {
  const LeaveSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, LeaveSessionUsecaseResult>> call(params) async {
    return quizRepository.leaveSession(params);
  }
}

class LeaveSessionUsecaseParams extends Params {
  final String sessionId;
  final String userId;
  const LeaveSessionUsecaseParams(
      {required this.sessionId, required this.userId});
}

class LeaveSessionUsecaseResult extends Response {
  final SessionEntity session;
  const LeaveSessionUsecaseResult({required this.session});
}
