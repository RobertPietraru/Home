import 'package:testador/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:testador/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:testador/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:testador/features/quiz/domain/usecases/draft/delete_draft_by_id.dart';
import 'package:testador/features/quiz/domain/usecases/session/show_leaderboard.dart';

import '../../injection.dart';
import 'data/datasources/quiz_remote_datasource.dart';
import 'domain/usecases/quiz_usecases.dart';

void quizInject() {
  locator
    ..registerSingleton<QuizLocalDataSource>(QuizLocalDataSourceIMPL())
    ..registerSingleton<QuizRemoteDataSource>(QuizRemoteDataSourceIMPL())
    ..registerSingleton<QuizRepository>(
        QuizRepositoryIMPL(locator(), locator()))
    ..registerSingleton(CreateDraftUsecase(locator()))
    ..registerSingleton(DeleteDraftByIdUsecase(locator()))
    ..registerSingleton(UpdateQuizUsecase(locator()))
    ..registerSingleton(GetQuizesUsecase(locator()))
    ..registerSingleton(InsertQuestionUsecase(locator()))
    ..registerSingleton(DeleteQuestionUsecase(locator()))
    ..registerSingleton(UpdateQuestionUsecase(locator()))
    ..registerSingleton(UpdateQuestionImageUsecase(locator()))
    ..registerSingleton(MoveQuestionUsecase(locator()))
    ..registerSingleton(UpdateQuizImageUsecase(locator()))
    ..registerSingleton(SyncQuizUsecase(locator()))
    ..registerSingleton(GetQuizByIdUsecase(locator()))
    ..registerSingleton(GetDraftByIdUsecase(locator()))
    ..registerSingleton(BeginSessionUsecase(locator()))
    ..registerSingleton(CreateSessionUsecase(locator()))
    ..registerSingleton(DeleteSessionUsecase(locator()))
    ..registerSingleton(EndSessionUsecase(locator()))
    ..registerSingleton(GoToNextQuestionUsecase(locator()))
    ..registerSingleton(JoinAsViewerUsecase(locator()))
    ..registerSingleton(JoinSessionUsecase(locator()))
    ..registerSingleton(KickFromSessionUsecase(locator()))
    ..registerSingleton(LeaveSessionUsecase(locator()))
    ..registerSingleton(SendAnswerUsecase(locator()))
    ..registerSingleton(ShowPodiumUsecase(locator()))
    ..registerSingleton(ShowQuestionResultsUsecase(locator()))
    ..registerSingleton(ShowLeaderboardUsecase(locator()))
    ..registerSingleton(SuggestQuestionAndOptionsUsecase(locator()))
    ..registerSingleton(SuggestOptionsUsecase(locator()))
    ..registerSingleton(SuggestEntireQuizUsecase(locator()))
    ..registerSingleton(SubscribeToSessionUsecase(locator()));
}
