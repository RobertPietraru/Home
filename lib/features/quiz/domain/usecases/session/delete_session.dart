import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class DeleteSessionUsecase
    extends UseCase<DeleteSessionUsecaseResult, DeleteSessionUsecaseParams> {
  const DeleteSessionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, DeleteSessionUsecaseResult>> call(params) async {
    return quizRepository.deleteSession(params);
  }
}

class DeleteSessionUsecaseParams extends Params {
  final SessionEntity session;
  const DeleteSessionUsecaseParams({required this.session});
}

class DeleteSessionUsecaseResult extends Response {
  const DeleteSessionUsecaseResult();
}
