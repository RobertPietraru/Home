import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class CreateSessionUsecase
    extends UseCase<CreateSessionUsecaseResult, CreateSessionUsecaseParams> {
  const CreateSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, CreateSessionUsecaseResult>> call(params) async {
    return quizRepository.createSession(params);
  }
}

class CreateSessionUsecaseParams extends Params {
  final QuizEntity quiz;
  final String creatorId;
  const CreateSessionUsecaseParams(
      {required this.creatorId, required this.quiz});
}

class CreateSessionUsecaseResult extends Response {
  final SessionEntity session;
  const CreateSessionUsecaseResult({required this.session});
}
