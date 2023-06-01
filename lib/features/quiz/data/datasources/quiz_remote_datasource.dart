import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/openai.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testador/features/quiz/data/dtos/draft/draft_dto.dart';
import 'package:testador/features/quiz/data/dtos/question/question_dto.dart';
import 'package:testador/features/quiz/data/dtos/quiz/quiz_dto.dart';
import 'package:testador/features/quiz/data/dtos/session/player_dto.dart';
import 'package:testador/features/quiz/data/dtos/session/session_dto.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/failures/session/player_name_already_in_use_failure.dart';
import 'package:testador/features/quiz/domain/failures/session/session_now_found_failure.dart';
import 'package:testador/features/quiz/domain/usecases/session/show_leaderboard.dart';

import '../../domain/usecases/quiz_usecases.dart';

const maxTriesForCodeCollision = 4;

abstract class QuizRemoteDataSource {
  Future<void> syncToDatabase(SyncQuizUsecaseParams params);
  Future<QuizEntity> getQuizById(GetQuizByIdUsecaseParams params);
  Future<List<QuizEntity>> getQuizes(GetQuizesUsecaseParams params);

  Future<ShowQuestionResultsUsecaseResult> showQuestionResults(
      ShowQuestionResultsUsecaseParams params);
  Future<ShowPodiumUsecaseResult> showPodium(ShowPodiumUsecaseParams params);
  Future<SendAnswerUsecaseResult> sendAnswer(SendAnswerUsecaseParams params);
  Future<LeaveSessionUsecaseResult> leaveSession(
      LeaveSessionUsecaseParams params);
  Future<KickFromSessionUsecaseResult> kickFromSession(
      KickFromSessionUsecaseParams params);
  Future<JoinSessionUsecaseResult> joinSession(JoinSessionUsecaseParams params);
  Future<JoinAsViewerUsecaseResult> joinAsViewer(
      JoinAsViewerUsecaseParams params);
  Future<GoToNextQuestionUsecaseResult> goToNextQuestion(
      GoToNextQuestionUsecaseParams params);
  Future<EndSessionUsecaseResult> endSession(EndSessionUsecaseParams params);
  Future<CreateSessionUsecaseResult> createSession(
      CreateSessionUsecaseParams params);
  Future<BeginSessionUsecaseResult> beginSession(
      BeginSessionUsecaseParams params);

  Future<DeleteSessionUsecaseResult> deleteSession(
      DeleteSessionUsecaseParams params);

  Future<SubscribeToSessionUsecaseResult> subscribeToSession(
      SubscribeToSessionUsecaseParams params);

  Future<ShowLeaderboardUsecaseResult> showLeaderboard(
      ShowLeaderboardUsecaseParams params);

  Future<SuggestEntireQuizUsecaseResult> suggestEntireQuiz(
      SuggestEntireQuizUsecaseParams params);
  Future<SuggestOptionsUsecaseResult> suggestOptions(
      SuggestOptionsUsecaseParams params);
  Future<SuggestQuestionAndOptionsUsecaseResult> suggestQuestionAndOptions(
      SuggestQuestionAndOptionsUsecaseParams params);
}

class QuizRemoteDataSourceIMPL implements QuizRemoteDataSource {
  final random = Random.secure();
  final firestore = FirebaseFirestore.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Future<void> syncToDatabase(SyncQuizUsecaseParams params) async {
    final quiz = DraftDto.fromEntity(params.draft);

    await firestore.collection('quizes').doc(quiz.id).set(quiz.toStringMap());
  }

  @override
  Future<QuizEntity> getQuizById(GetQuizByIdUsecaseParams params) async {
    final doc = await firestore.collection('quizes').doc(params.quizId).get();
    if (doc.data() == null) throw const QuizNotFoundFailure();
    return QuizDto.fromMap(doc.data()!).toEntity();
  }

  @override
  Future<List<QuizEntity>> getQuizes(GetQuizesUsecaseParams params) async {
    final snap = await firestore
        .collection(QuizDto.collection)
        .where(QuizDto.creatorField, isEqualTo: params.creatorId)
        .get();
    return snap.docs.map((e) => QuizDto.fromMap(e.data()).toEntity()).toList();
  }

  @override
  Future<BeginSessionUsecaseResult> beginSession(
      BeginSessionUsecaseParams params) async {
    final newSession = SessionDto.fromEntity(params.session)
        .copyWith(status: SessionStatus.question, answers: []);

    await _writeSessionToDB(newSession);
    return BeginSessionUsecaseResult(session: newSession.toEntity());
  }

  /// return null means max tries were reached and it's still colliding
  Future<String?> createCodeWithoutCollision(
      {required DatabaseReference sessions}) async {
    var id = _generateQuizCode(7);
    for (var i = 0; i < maxTriesForCodeCollision; i++) {
      final session = await sessions.child(id).get();
      if (session.exists) {
        id = _generateQuizCode(7);
      } else {
        return id;
      }
    }
    return null;
  }

  @override
  Future<CreateSessionUsecaseResult> createSession(
      CreateSessionUsecaseParams params) async {
    final sessions = ref.child('sessions');
    final code = await createCodeWithoutCollision(sessions: sessions);

    if (code == null) {
      throw const QuizUnknownFailure(code: 'quiz-code-collision');
    }

    final session = SessionDto(
      id: code,
      quizId: params.quiz.id,
      students: const [],
      currentQuestionId: params.quiz.questions.first.id,
      answers: const [],
      status: SessionStatus.waitingForPlayers,
    );
    await ref.child('sessions').child(code).set(session.toMap());

    return CreateSessionUsecaseResult(session: session.toEntity());
  }

  String _generateQuizCode(int codeLength) =>
      List.generate(codeLength, (index) => random.nextInt(10)).join();

  @override
  Future<EndSessionUsecaseResult> endSession(
      EndSessionUsecaseParams params) async {
    final newSession = SessionDto.fromEntity(params.session)
        .copyWith(status: SessionStatus.done, answers: []);
    //TODO: save to firestore so the teacher can like, revisit this stuff
    await _writeSessionToDB(newSession);
    return EndSessionUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<GoToNextQuestionUsecaseResult> goToNextQuestion(
      GoToNextQuestionUsecaseParams params) async {
    final currentQuestionIndex = params.quiz.questions.indexWhere(
        (element) => element.id == params.session.currentQuestionId);
    if (currentQuestionIndex == -1) {
      throw const QuizUnknownFailure();
    }
    late final SessionDto newSession;

    if (currentQuestionIndex == params.quiz.questions.length - 1) {
      newSession = SessionDto.fromEntity(params.session).copyWith(
        status: SessionStatus.podium,
        answers: [],
      );
    } else {
      newSession = SessionDto.fromEntity(params.session).copyWith(
        status: SessionStatus.question,
        currentQuestionId: params.quiz.questions[currentQuestionIndex + 1].id,
        answers: [],
      );
    }

    await _writeSessionToDB(newSession);
    return GoToNextQuestionUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<JoinAsViewerUsecaseResult> joinAsViewer(
      JoinAsViewerUsecaseParams params) {
    // TODO: implement joinAsViewer
    throw UnimplementedError();
  }

  @override
  Future<JoinSessionUsecaseResult> joinSession(
      JoinSessionUsecaseParams params) async {
    SessionDto session = await _getSessionFromDB(params.sessionId);
    final nameAlreadyUsed =
        session.students.indexWhere((element) => element.name == params.name) !=
            -1;

    if (nameAlreadyUsed) throw PlayerNameAlreadyInUseQuizFailure();
    final students = session.students.toList();
    students.add(PlayerDto(
        userId: params.userId, name: params.name, score: 0, correctAnswers: 0));
    final newSession = session.copyWith(students: students);

    await _writeSessionToDB(newSession);

    return JoinSessionUsecaseResult(session: newSession.toEntity());
  }

  Future<SessionDto> _getSessionFromDB(String sessionId) async {
    final sessionSnapshot = await ref.child('sessions').child(sessionId).get();
    if (!sessionSnapshot.exists) {
      throw const SessionNotFoundFailure();
    }

    final data = sessionSnapshot.value as Map<dynamic, dynamic>;
    final session = SessionDto.fromMap(data, sessionId);

    return session;
  }

  Future<void> _writeSessionToDB(SessionDto session) async =>
      await ref.child('sessions').child(session.id).set(session.toMap());

  @override
  Future<KickFromSessionUsecaseResult> kickFromSession(
      KickFromSessionUsecaseParams params) async {
    final session = await _getSessionFromDB(params.sessionId);

    final indexOfUser = session.students
        .indexWhere((element) => element.userId == params.userId);
    late SessionDto newSession;

    if (indexOfUser != -1) {
      final students = session.students.toList();
      students.removeAt(indexOfUser);
      newSession = session.copyWith(students: students);

      await ref.child('sessions').child(newSession.id).set(newSession.toMap());
    } else {
      newSession = session;
    }

    return KickFromSessionUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<LeaveSessionUsecaseResult> leaveSession(
      LeaveSessionUsecaseParams params) async {
    final session = await _getSessionFromDB(params.sessionId);

    final indexOfUser = session.students
        .indexWhere((element) => element.userId == params.userId);
    late SessionDto newSession;
    if (indexOfUser != -1) {
      final students = session.students.toList();
      students.removeAt(indexOfUser);
      newSession = session.copyWith(students: students);

      await ref.child('sessions').child(newSession.id).set(newSession.toMap());
    } else {
      newSession = session;
    }

    return LeaveSessionUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<SendAnswerUsecaseResult> sendAnswer(
      SendAnswerUsecaseParams params) async {
    final session = await _getSessionFromDB(params.sessionId);

    final answers = session.answers.toList();
    answers.add(SessionAnswerDto(
        userId: params.userId,
        optionIndexes: params.answerIndexes,
        responseTime: params.responseTime));
    final newSession = session.copyWith(answers: answers);

    await _writeSessionToDB(newSession);

    return SendAnswerUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<ShowPodiumUsecaseResult> showPodium(
      ShowPodiumUsecaseParams params) async {
    final session = SessionDto.fromEntity(params.session)
        .copyWith(status: SessionStatus.podium);
    await _writeSessionToDB(session);
    return ShowPodiumUsecaseResult(session: session.toEntity());
  }

  @override
  Future<ShowQuestionResultsUsecaseResult> showQuestionResults(
      ShowQuestionResultsUsecaseParams params) async {
    final session = SessionDto.fromEntity(params.session);
    final question = params.quiz.questions
        .firstWhere((element) => element.id == session.currentQuestionId);
    var students = session.students.toList();

    for (var answerDto in session.answers) {
      bool addPoints = true;
      for (int option in answerDto.optionIndexes ?? []) {
        if (!question.options[option].isCorrect) {
          addPoints = false;
          break;
        }
      }

      if (addPoints) {
        final index = students
            .indexWhere((element) => element.userId == answerDto.userId);
        if (index != -1) {
          final student = students[index];
          students[index] = students[index].copyWith(
              score:
                  student.score + 60 + (40 - answerDto.responseTime.inSeconds),
              correctAnswers: student.correctAnswers + 1);
        }
      }
    }

    final newSession =
        session.copyWith(students: students, status: SessionStatus.results);

    await ref.child('sessions').child(newSession.id).set(newSession.toMap());

    return ShowQuestionResultsUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<DeleteSessionUsecaseResult> deleteSession(
      DeleteSessionUsecaseParams params) async {
    await ref.child('sessions').child(params.session.id).remove();
    return const DeleteSessionUsecaseResult();
  }

  @override
  Future<SubscribeToSessionUsecaseResult> subscribeToSession(
      SubscribeToSessionUsecaseParams params) async {
    final stream = ref.child('sessions').child(params.sessionId).onValue;
    if (params.sessionId.isEmpty) {
      throw const SessionNotFoundFailure();
    }
    final data = (await ref.child('sessions').child(params.sessionId).get())
        .value as Map<dynamic, dynamic>?;
    if (data == null) {
      throw const SessionNotFoundFailure();
    }
    final session = SessionDto.fromMap(data, params.sessionId).toEntity();
    Stream<SessionEntity> sessionStream = stream
        .transform(StreamTransformer<DatabaseEvent, SessionEntity>.fromHandlers(
      handleData: (DatabaseEvent event, EventSink<SessionEntity> sink) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) return;
        sink.add(SessionDto.fromMap(data, event.snapshot.key!).toEntity());
      },
    ));

    return SubscribeToSessionUsecaseResult(
        sessions: sessionStream, currentSession: session);
  }

  @override
  Future<ShowLeaderboardUsecaseResult> showLeaderboard(
      ShowLeaderboardUsecaseParams params) async {
    final session = SessionDto.fromEntity(params.session);
    var students = session.students.toList();

    final newSession =
        session.copyWith(students: students, status: SessionStatus.leaderboard);

    await ref.child('sessions').child(newSession.id).set(newSession.toMap());

    return ShowLeaderboardUsecaseResult(session: newSession.toEntity());
  }

  @override
  Future<SuggestEntireQuizUsecaseResult> suggestEntireQuiz(
      SuggestEntireQuizUsecaseParams params) {
    throw UnimplementedError();
  }

  @override
  Future<SuggestOptionsUsecaseResult> suggestOptions(
      SuggestOptionsUsecaseParams params) async {
    final questions =
        params.draft.questions.map((e) => QuestionDto.fromEntity(e)).toList();

    final question = questions[params.questionIndex];

    final information = params.draft.lesson == null
        ? 'Provide'
        : 'Given this information "${params.draft.lesson!}", provide';
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content:
              '$information 4 multiple choice options for the question "${question.text}". I want the result to be in json format, a list of objects with text field, index field and isCorrect field. Also, the values should be different. Answer in the language of the question, unless mentioned otherwise in the question. Don\'t provide any other explanation',
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );

    final data = (jsonDecode(chatCompletion.choices.first.message.content)
        .cast<Map<String, dynamic>>()) as List<Map<String, dynamic>>;
    questions[params.questionIndex] = question.copyWith(
      options: data.map((e) => MultipleChoiceOptionDto.fromMap(e)).toList(),
    );

    return SuggestOptionsUsecaseResult(
        draft: params.draft
            .copyWith(questions: questions.map((e) => e.toEntity()).toList()));
  }

  @override
  Future<SuggestQuestionAndOptionsUsecaseResult> suggestQuestionAndOptions(
      SuggestQuestionAndOptionsUsecaseParams params) {
    // not for mvp after all
    throw UnimplementedError();
  }
}
