import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'question_timer_state.dart';

class QuestionTimerCubit extends Cubit<QuestionTimerState> {
  QuestionTimerCubit({required int time})
      : super(QuestionTimerState(time: time)) {
    startTimer();
  }

  late Timer _timer;
  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (state.time == 0) {
          timer.cancel();
        } else {
          emit(QuestionTimerState(time: state.time - 1));
        }
      },
    );
  }
}
