import 'package:equatable/equatable.dart';
import 'package:testador/core/globals.dart';
import 'package:testador/features/quiz/domain/entities/session/player_entity.dart';

enum SessionStatus {
  waitingForPlayers,
  question,
  results,
  leaderboard,
  podium,
  done;

  static Map<SessionStatus, String> get _conversionMap => {
        SessionStatus.results: 'results',
        SessionStatus.leaderboard: 'leaderboard',
        SessionStatus.podium: 'podium',
        SessionStatus.question: 'question',
        SessionStatus.waitingForPlayers: 'waitingForPlayers',
        SessionStatus.done: 'done',
      };

  String asString() {
    return _conversionMap[this] ??
        _conversionMap[SessionStatus.waitingForPlayers]!;
  }

  static SessionStatus fromString(String data) {
    final reversedConversionMap =
        _conversionMap.map((key, value) => MapEntry(value, key));
    return reversedConversionMap[data] ?? SessionStatus.waitingForPlayers;
  }
}

class SessionEntity extends Equatable {
  final String id;
  final String quizId;
  final SessionStatus status;
  final List<PlayerEntity> students;
  final String currentQuestionId;
  final List<SessionAnswer> answers;

  const SessionEntity({
    required this.id,
    required this.quizId,
    required this.students,
    required this.currentQuestionId,
    required this.answers,
    required this.status,
  });

  @override
  List<Object> get props =>
      [id, quizId, students, currentQuestionId, answers, status];

  SessionEntity copyWith({
    String? id,
    String? quizId,
    List<PlayerEntity>? students,
    String? currentQuestionId,
    List<SessionAnswer>? answers,
    SessionStatus? status,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      students: students ?? this.students,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      answers: answers ?? this.answers,
      status: status ?? this.status,
    );
  }
}

class SessionAnswer extends Equatable {
  final String userId;
  final List<int>? optionIndexes;
  final String? answer;
  final Duration responseTime;

  const SessionAnswer(
      {required this.userId,
      this.optionIndexes,
      this.answer,
      required this.responseTime});

  @override
  List<Object?> get props =>
      [userId, ...(optionIndexes ?? []), answer, responseTime];

  SessionAnswer copyWith({
    String? userId,
    List<int>? optionIndexes,
    String? answer = DefaultValues.forStrings,
    Duration? responseTime,
  }) {
    return SessionAnswer(
      userId: userId ?? this.userId,
      optionIndexes: optionIndexes ?? this.optionIndexes,
      answer: answer ?? this.answer,
      responseTime: responseTime ?? this.responseTime,
    );
  }
}
