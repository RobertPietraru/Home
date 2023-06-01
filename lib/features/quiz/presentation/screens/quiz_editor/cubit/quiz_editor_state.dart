part of 'quiz_editor_cubit.dart';

enum QuizEditorStatus { loading, loaded, failed }

class QuizEditorState extends Equatable {
  final QuizEntity lastSavedQuiz;
  final DraftEntity draft;
  final QuizFailure? failure;
  final QuizEditorStatus status;
  final int currentQuestionIndex;

  const QuizEditorState({
    required this.currentQuestionIndex,
    this.status = QuizEditorStatus.loading,
    required this.lastSavedQuiz,
    required this.draft,
    this.failure,
  });

  QuestionEntity get currentQuestion => draft.questions[currentQuestionIndex];

  bool get needsSync => draft.toQuiz() != lastSavedQuiz;

  QuizEditorState copyWith(
      {QuizEntity? lastSavedQuiz,
      DraftEntity? draft,
      QuizFailure? failure,
      QuizEditorStatus? status,
      int? currentQuestionIndex,
      bool updateError = false}) {
    return QuizEditorState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      status: status ?? this.status,
      lastSavedQuiz: lastSavedQuiz ?? this.lastSavedQuiz,
      draft: draft ?? this.draft,
      failure: updateError ? failure : this.failure,
    );
  }

  @override
  List<Object?> get props => [
        currentQuestionIndex,
        currentQuestion,
        lastSavedQuiz,
        draft,
        failure,
        status
      ];
}
