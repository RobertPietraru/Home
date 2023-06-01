import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/globals.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:testador/features/quiz/presentation/session/timer/question_timer_cubit.dart';

part 'player_question_state.dart';

class PlayerQuestionCubit extends Cubit<PlayerQuestionState> {
  final SendAnswerUsecase sendAnswerUsecase;
  final QuestionTimerCubit timer;
  final String userId;
  PlayerQuestionCubit(
    this.sendAnswerUsecase, {
    required this.userId,
    required this.timer,
    required SessionEntity session,
    required QuestionEntity question,
    required int questionindex,
  }) : super(
          PlayerQuestionState(
              session: session,
              status: PlayerQuestionStatus.thinking,
              question: question,
              selectedAnswerIndexes: const [],
              questionIndex: questionindex),
        );
  void ranOutOfTime() {
    emit(state.copyWith(status: PlayerQuestionStatus.outOfTime));
  }

  void selectAnswer(int index) {
    emit(state.copyWith(
        selectedAnswerIndexes: [index, ...state.selectedAnswerIndexes]));
  }

  Future<void> onAnswerPressed(int index) async {
    if (!state.question.hasMultipleAnswers) {
      await _sendAnswer([index], timer.state.time);
      return;
    }
    // are mai multe acum
    if (state.selectedAnswerIndexes.contains(index)) {
      final indexes = state.selectedAnswerIndexes.toList();
      indexes.remove(index);
      emit(state.copyWith(selectedAnswerIndexes: indexes));
      return;
    } else {
      selectAnswer(index);
    }
  }

  void sendSelectedAnswers() {
    _sendAnswer(state.selectedAnswerIndexes, timer.state.time);
  }

  Future<void> _sendAnswer(List<int> indexes, int secondsLeft) async {
    final response = await sendAnswerUsecase.call(SendAnswerUsecaseParams(
        sessionId: state.session.id,
        userId: userId,
        answerIndexes: indexes,
        responseTime: Duration(seconds: 40 - secondsLeft)));
    response.fold((l) {
      emit(state.copyWith(
        failure: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: PlayerQuestionStatus.answered,
        selectedAnswerIndexes: const [],
        failure: null,
        session: r.session,
      ));
    });
  }
}
