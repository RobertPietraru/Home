import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

part 'task_filtering_state.dart';

class TaskFilteringCubit extends Cubit<TaskFilteringState> {
  final TasksCubit tasksCubit;
  TaskFilteringState? lastState;
  TaskFilteringCubit({required this.tasksCubit})
      : super(TaskFilteringState.initial());

  void makeCheckpoint() {
    lastState = state.copyWith();
  }

  void reset() {
    emit(TaskFilteringState.initial());
    makeCheckpoint();
  }

  void cancel() {
    emit(lastState ?? TaskFilteringState.initial());
    makeCheckpoint();
  }

  void toggleSortFilter(TaskSortFilter target) {
    if (state.sortFilters.contains(target)) {
      emit(state.copyWith(
          sortFilters: state.sortFilters
              .where((element) => element != target)
              .toList()));
      return;
    }
    final list = state.sortFilters.toList();

    if (state.sortFilters.length >= 2) {
      list[0] = list[1];
      list[1] = target;
    } else {
      list.add(target);
    }
    emit(state.copyWith(sortFilters: list));
  }

  void setShowComletedTasks(bool showCompletedTasks) {
    emit(state.copyWith(showCompletedTasks: showCompletedTasks));
  }

  // void selectAssignee(UserEntity? assignee) {
  //   emit(state.copyWith(selectedAsignee: assignee));
  // }

  void apply(Translator translator) {
    tasksCubit.updateFilters(state.filter, translator);
  }
}
