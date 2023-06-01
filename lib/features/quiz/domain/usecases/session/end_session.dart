import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class EndSessionUsecase
    extends UseCase<EndSessionUsecaseResult, EndSessionUsecaseParams> {
  const EndSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, EndSessionUsecaseResult>> call(params) async {
    return quizRepository.endSession(params);
  }
}

class EndSessionUsecaseParams extends Params {
  final SessionEntity session;
  const EndSessionUsecaseParams({required this.session});
}

class EndSessionUsecaseResult extends Response {
  final SessionEntity session;
  const EndSessionUsecaseResult({required this.session});
}
