import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/openai.dart';
import 'package:dartz/dartz.dart';
import 'package:testador/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:testador/features/quiz/data/datasources/quiz_remote_datasource.dart';
import 'package:testador/features/quiz/domain/failures/quiz_editor/generation_in_cooldown_failure.dart';
import 'package:testador/features/quiz/domain/failures/quiz_editor/generation_unknown_failure.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_question_and_answers.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_options.dart';
import 'package:testador/features/quiz/domain/usecases/ai/suggest_entire_quiz.dart';
import 'package:testador/features/quiz/domain/usecases/draft/delete_draft_by_id.dart';
import 'package:testador/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:testador/features/quiz/domain/usecases/session/show_leaderboard.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryIMPL implements QuizRepository {
  const QuizRepositoryIMPL(
    this.quizLocalDataSource,
    this.quizRemoteDataSource,
  );

  final QuizLocalDataSource quizLocalDataSource;
  final QuizRemoteDataSource quizRemoteDataSource;

  @override
  Future<Either<QuizFailure, CreateDraftUsecaseResult>> createQuiz(
      CreateDraftUsecaseParams params) async {
    try {
      final quizEntity = await quizLocalDataSource.createDraft(params);
      return Right(CreateDraftUsecaseResult(draft: quizEntity));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, DeleteQuestionUsecaseResult>> deleteQuestion(
      DeleteQuestionUsecaseParams params) async {
    try {
      final quizEntity = await quizLocalDataSource.deleteQuestion(params);
      return Right(DeleteQuestionUsecaseResult(quizEntity: quizEntity));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, InsertQuestionUsecaseResult>> insertQuestion(
      InsertQuestionUsecaseParams params) async {
    try {
      final response = await quizLocalDataSource.insertQuestion(params);
      return Right(InsertQuestionUsecaseResult(draft: response));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, UpdateQuestionUsecaseResult>> updateQuestion(
      UpdateQuestionUsecaseParams params) async {
    try {
      final quizEntity = await quizLocalDataSource.updateQuestion(params);
      return Right(UpdateQuestionUsecaseResult(quizEntity: quizEntity));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, EditQuizUsecaseResult>> editQuiz(
      UpdateQuizUsecaseParams params) async {
    try {
      final quizEntity = await quizLocalDataSource.updateQuiz(params);
      return Right(EditQuizUsecaseResult(quiz: quizEntity));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, GetQuizesUsecaseResult>> getQuizes(
      GetQuizesUsecaseParams params) async {
    try {
      final quizes = await quizRemoteDataSource.getQuizes(params);
      final drafts = await quizLocalDataSource.getDrafts(params);

      return Right(GetQuizesUsecaseResult(
          pairs: quizes.map((quiz) {
        final index = drafts.indexWhere((draft) => draft.id == quiz.id);

        return QuizDraftPair(
            quiz: quiz, draft: index == -1 ? null : drafts[index]);
      }).toList()));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } on Error catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, GetDraftByIdUsecaseResult>> getDraftById(
      GetDraftByIdUsecaseParams params) async {
    try {
      final quiz = await quizLocalDataSource.getDraftById(params);
      return Right(GetDraftByIdUsecaseResult(draft: quiz));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, MoveQuestionUsecaseResult>> moveQuestion(
      MoveQuestionUsecaseParams params) async {
    try {
      final quiz = await quizLocalDataSource.moveQuestion(params);
      return Right(MoveQuestionUsecaseResult(quiz: quiz));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, UpdateQuestionImageUsecaseResult>>
      updateQuestionImage(UpdateQuestionImageUsecaseParams params) async {
    try {
      final quiz = await quizLocalDataSource.updateQuestionImage(params);
      return Right(UpdateQuestionImageUsecaseResult(quiz: quiz));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, UpdateQuizImageUsecaseResult>> updateQuizImage(
      UpdateQuizImageUsecaseParams params) async {
    try {
      final quiz = await quizLocalDataSource.updateQuizImage(params);
      return Right(UpdateQuizImageUsecaseResult(quiz: quiz));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SyncQuizUsecaseResult>> syncQuiz(
      SyncQuizUsecaseParams params) async {
    try {
      quizRemoteDataSource.syncToDatabase(params);
      return const Right(SyncQuizUsecaseResult());
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, GetQuizByIdUsecaseResult>> getQuizById(
      GetQuizByIdUsecaseParams params) async {
    try {
      final quiz = await quizRemoteDataSource.getQuizById(params);
      return Right(GetQuizByIdUsecaseResult(quiz: quiz));
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, DeleteDraftByIdUsecaseResult>> deleteDraftById(
      DeleteDraftByIdUsecaseParams params) async {
    try {
      await quizLocalDataSource.deleteDraftById(params);
      return const Right(DeleteDraftByIdUsecaseResult());
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, BeginSessionUsecaseResult>> beginSession(
      BeginSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.beginSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, CreateSessionUsecaseResult>> createSession(
      CreateSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.createSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } on Error catch (_) {
      print(_.toString());
      print(_.stackTrace);
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, EndSessionUsecaseResult>> endSession(
      EndSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.endSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, GoToNextQuestionUsecaseResult>> goToNextQuestion(
      GoToNextQuestionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.goToNextQuestion(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, JoinAsViewerUsecaseResult>> joinAsViewer(
      JoinAsViewerUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.joinAsViewer(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, JoinSessionUsecaseResult>> joinSession(
      JoinSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.joinSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      print(_);
      print((_ as Error).stackTrace);
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, KickFromSessionUsecaseResult>> kickFromSession(
      KickFromSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.kickFromSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, LeaveSessionUsecaseResult>> leaveSession(
      LeaveSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.leaveSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SendAnswerUsecaseResult>> sendAnswer(
      SendAnswerUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.sendAnswer(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, ShowPodiumUsecaseResult>> showPodium(
      ShowPodiumUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.showPodium(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, ShowQuestionResultsUsecaseResult>>
      showQuestionResults(ShowQuestionResultsUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.showQuestionResults(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, DeleteSessionUsecaseResult>> deleteSession(
      DeleteSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.deleteSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SubscribeToSessionUsecaseResult>>
      subscribeToSession(SubscribeToSessionUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.subscribeToSession(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, ShowLeaderboardUsecaseResult>> showLeaderboard(
      ShowLeaderboardUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.showLeaderboard(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SuggestEntireQuizUsecaseResult>> suggestEntireQuiz(
      SuggestEntireQuizUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.suggestEntireQuiz(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SuggestOptionsUsecaseResult>> suggestOptions(
      SuggestOptionsUsecaseParams params) async {
    try {
      final response = await quizRemoteDataSource.suggestOptions(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } on RequestFailedException catch (error) {
      if (error.statusCode == 429) {
        return Left(GenerationInCooldownQuizFailure());
      }
      return Left(GenerationUnknownQuizFailure(status: error.statusCode));
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }

  @override
  Future<Either<QuizFailure, SuggestQuestionAndOptionsUsecaseResult>>
      suggestQuestionAndOptions(
          SuggestQuestionAndOptionsUsecaseParams params) async {
    try {
      final response =
          await quizRemoteDataSource.suggestQuestionAndOptions(params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(QuizUnknownFailure(code: e.code));
    } on QuizFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(QuizUnknownFailure());
    }
  }
}
