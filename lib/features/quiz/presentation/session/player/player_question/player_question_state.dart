part of 'player_question_cubit.dart';

enum PlayerQuestionStatus { thinking, loading, answered, outOfTime }

class PlayerQuestionState extends Equatable {
  final SessionEntity session;
  final PlayerQuestionStatus status;
  final QuestionEntity question;
  final int questionIndex;
  final QuizFailure? failure;

  final List<int> selectedAnswerIndexes;

  const PlayerQuestionState({
    this.failure,
    required this.questionIndex,
    required this.session,
    required this.status,
    required this.question,
    required this.selectedAnswerIndexes,
  });

  PlayerQuestionState copyWith({
    SessionEntity? session,
    PlayerQuestionStatus? status,
    QuestionEntity? question,
    List<int>? selectedAnswerIndexes,
    int? questionIndex,
    QuizFailure? failure = DefaultValues.forQuizfailure,
  }) {
    return PlayerQuestionState(
      session: session ?? this.session,
      status: status ?? this.status,
      question: question ?? this.question,
      failure: failure == DefaultValues.forQuizfailure ? this.failure : failure,
      selectedAnswerIndexes:
          selectedAnswerIndexes ?? this.selectedAnswerIndexes,
      questionIndex: questionIndex ?? this.questionIndex,
    );
  }

  @override
  List<Object> get props =>
      [session, status, question, ...selectedAnswerIndexes];
}
