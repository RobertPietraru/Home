import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class ShowLeaderboardUsecase extends UseCase<ShowLeaderboardUsecaseResult,
    ShowLeaderboardUsecaseParams> {
  const ShowLeaderboardUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, ShowLeaderboardUsecaseResult>> call(params) async {
    return quizRepository.showLeaderboard(params);
  }
}

class ShowLeaderboardUsecaseParams extends Params {
  final SessionEntity session;

  ShowLeaderboardUsecaseParams({required this.session});
}

class ShowLeaderboardUsecaseResult extends Response {
  final SessionEntity session;
  const ShowLeaderboardUsecaseResult({required this.session});
}
