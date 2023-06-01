part of 'session_admin_cubit.dart';

abstract class SessionAdminState extends Equatable {
  final QuizEntity quiz;
  const SessionAdminState({required this.quiz});
}

class SessionAdminMatchState extends SessionAdminState {
  final SessionEntity session;
  final QuizFailure? failure;
  const SessionAdminMatchState(
      {required super.quiz, required this.session, this.failure});

  @override
  List<Object?> get props => [quiz, session, failure];
  SessionAdminMatchState copyWith({
    QuizEntity? quiz,
    SessionEntity? session,
    QuizFailure? failure = const QuizUnknownFailure(code: 'fake-error'),
  }) {
    return SessionAdminMatchState(
      quiz: quiz ?? this.quiz,
      session: session ?? this.session,
      failure: failure == const QuizUnknownFailure(code: 'fake-error')
          ? this.failure
          : failure,
    );
  }

  int get currentQuestionIndex => quiz.questions .indexWhere((element) => element.id == session.currentQuestionId);
  QuestionEntity get currentQuestion => quiz.questions[currentQuestionIndex];
}

class SessionAdminLoadingState extends SessionAdminState {
  const SessionAdminLoadingState({required super.quiz});

  @override
  List<Object?> get props => [quiz];
}

class SessionAdminFailureState extends SessionAdminState {
  final QuizFailure failure;
  const SessionAdminFailureState({required super.quiz, required this.failure});

  @override
  List<Object?> get props => [quiz, failure];
}

class SessionAdminDeletedState extends SessionAdminState {
  const SessionAdminDeletedState({required super.quiz});

  @override
  List<Object?> get props => [quiz];
}
