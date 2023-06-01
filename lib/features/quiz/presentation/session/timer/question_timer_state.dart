part of 'question_timer_cubit.dart';

class QuestionTimerState extends Equatable {
  final int time;
  const QuestionTimerState({required this.time});

  @override
  List<Object> get props => [time];
}
