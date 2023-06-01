import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_entire_quiz.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_options.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_question_and_answers.dart';
import 'package:testador/features/quiz/domain/usecases/draft/delete_draft_by_id.dart';
import 'package:testador/features/quiz/domain/usecases/session/delete_session.dart';
import 'package:testador/features/quiz/domain/usecases/session/show_leaderboard.dart';
import 'package:testador/features/quiz/domain/usecases/session/subscribe_to_session.dart';

import '../failures/quiz_failures.dart';
import '../usecases/quiz_usecases.dart';

abstract class QuizRepository {
  Future<Either<QuizFailure, GetDraftByIdUsecaseResult>> getDraftById(
      GetDraftByIdUsecaseParams params);
  Future<Either<QuizFailure, GetQuizByIdUsecaseResult>> getQuizById(
      GetQuizByIdUsecaseParams params);
  Future<Either<QuizFailure, GetQuizesUsecaseResult>> getQuizes(
      GetQuizesUsecaseParams params);
  Future<Either<QuizFailure, UpdateQuestionImageUsecaseResult>>
      updateQuestionImage(UpdateQuestionImageUsecaseParams params);
  Future<Either<QuizFailure, UpdateQuizImageUsecaseResult>> updateQuizImage(
      UpdateQuizImageUsecaseParams params);
  Future<Either<QuizFailure, SyncQuizUsecaseResult>> syncQuiz(
      SyncQuizUsecaseParams params);

  Future<Either<QuizFailure, CreateDraftUsecaseResult>> createQuiz(
      CreateDraftUsecaseParams params);
  Future<Either<QuizFailure, EditQuizUsecaseResult>> editQuiz(
      UpdateQuizUsecaseParams params);

  Future<Either<QuizFailure, MoveQuestionUsecaseResult>> moveQuestion(
      MoveQuestionUsecaseParams params);
  Future<Either<QuizFailure, InsertQuestionUsecaseResult>> insertQuestion(
      InsertQuestionUsecaseParams params);
  Future<Either<QuizFailure, DeleteQuestionUsecaseResult>> deleteQuestion(
      DeleteQuestionUsecaseParams params);
  Future<Either<QuizFailure, UpdateQuestionUsecaseResult>> updateQuestion(
      UpdateQuestionUsecaseParams params);

  Future<Either<QuizFailure, DeleteDraftByIdUsecaseResult>> deleteDraftById(
      DeleteDraftByIdUsecaseParams params);
  // game session

  Future<Either<QuizFailure, ShowQuestionResultsUsecaseResult>>
      showQuestionResults(ShowQuestionResultsUsecaseParams params);
  Future<Either<QuizFailure, ShowPodiumUsecaseResult>> showPodium(
      ShowPodiumUsecaseParams params);
  Future<Either<QuizFailure, SendAnswerUsecaseResult>> sendAnswer(
      SendAnswerUsecaseParams params);
  Future<Either<QuizFailure, LeaveSessionUsecaseResult>> leaveSession(
      LeaveSessionUsecaseParams params);
  Future<Either<QuizFailure, KickFromSessionUsecaseResult>> kickFromSession(
      KickFromSessionUsecaseParams params);
  Future<Either<QuizFailure, JoinSessionUsecaseResult>> joinSession(
      JoinSessionUsecaseParams params);
  Future<Either<QuizFailure, JoinAsViewerUsecaseResult>> joinAsViewer(
      JoinAsViewerUsecaseParams params);
  Future<Either<QuizFailure, GoToNextQuestionUsecaseResult>> goToNextQuestion(
      GoToNextQuestionUsecaseParams params);
  Future<Either<QuizFailure, EndSessionUsecaseResult>> endSession(
      EndSessionUsecaseParams params);
  Future<Either<QuizFailure, CreateSessionUsecaseResult>> createSession(
      CreateSessionUsecaseParams params);
  Future<Either<QuizFailure, BeginSessionUsecaseResult>> beginSession(
      BeginSessionUsecaseParams params);

  Future<Either<QuizFailure, DeleteSessionUsecaseResult>> deleteSession(
      DeleteSessionUsecaseParams params);

  Future<Either<QuizFailure, SubscribeToSessionUsecaseResult>>
      subscribeToSession(SubscribeToSessionUsecaseParams params);

  Future<Either<QuizFailure, ShowLeaderboardUsecaseResult>> showLeaderboard(
      ShowLeaderboardUsecaseParams params);

  Future<Either<QuizFailure, SuggestOptionsUsecaseResult>> suggestOptions(
      SuggestOptionsUsecaseParams params);
  Future<Either<QuizFailure, SuggestEntireQuizUsecaseResult>> suggestEntireQuiz(
      SuggestEntireQuizUsecaseParams params);
  Future<Either<QuizFailure, SuggestQuestionAndOptionsUsecaseResult>>
      suggestQuestionAndOptions(SuggestQuestionAndOptionsUsecaseParams params);
}

// create session (generates code and all that)
// join session (select name)
// leave session 
// kick from session
// begin session
// end session


// show question results (end question answering time)
// go to next question
// send answer
// show podium