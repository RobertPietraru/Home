import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class ShowPodiumUsecase
    extends UseCase<ShowPodiumUsecaseResult, ShowPodiumUsecaseParams> {
  const ShowPodiumUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, ShowPodiumUsecaseResult>> call(params) async {
    return quizRepository.showPodium(params);
  }
}

class ShowPodiumUsecaseParams extends Params {
  final SessionEntity session;
  const ShowPodiumUsecaseParams({required this.session});
}

class ShowPodiumUsecaseResult extends Response {
  final SessionEntity session;
  const ShowPodiumUsecaseResult({required this.session});
}
