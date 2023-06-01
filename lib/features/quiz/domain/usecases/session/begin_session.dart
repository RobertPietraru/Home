import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class BeginSessionUsecase
    extends UseCase<BeginSessionUsecaseResult, BeginSessionUsecaseParams> {
  const BeginSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, BeginSessionUsecaseResult>> call(params) async {
    return quizRepository.beginSession(params);
  }
}

class BeginSessionUsecaseParams extends Params {
  final SessionEntity session;

  const BeginSessionUsecaseParams({required this.session});
}

class BeginSessionUsecaseResult extends Response {
  final SessionEntity session;
  const BeginSessionUsecaseResult({required this.session});
}
