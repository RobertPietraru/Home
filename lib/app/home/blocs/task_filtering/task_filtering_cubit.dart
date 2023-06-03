import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

part 'task_filtering_state.dart';

class TaskFilteringCubit extends Cubit<TaskFilteringState> {
  final TasksCubit tasksCubit;
  TaskFilteringCubit(this.tasksCubit) : super(TaskFilteringState.initial());

  void reset() {
    emit(TaskFilteringState.initial());
  }

  void toggleSortOption(FilterSortTarget target) {
    if (state.sortByFields.contains(target)) {
      emit(state.copyWith(
          sortByFields: state.sortByFields
              .where((element) => element != target)
              .toList()));
      return;
    }
    final list = state.sortByFields.toList();

    if (state.sortByFields.length >= 2) {
      list[0] = list[1];
      list[1] = target;
    } else {
      list.add(target);
    }
    emit(state.copyWith(sortByFields: list));
  }

  void setShowComletedTasks(bool showCompletedTasks) {
    emit(state.copyWith(showCompletedTasks: showCompletedTasks));
  }

  void selectAssignee(UserEntity? assignee) {
    emit(state.copyWith(selectedAsignee: assignee));
  }

  void apply(TaskType type, HomeEntity home, Translator translator) {
    if (type == TaskType.chore) {
      tasksCubit.getChores(home: home, translator: translator);
    } else {
      tasksCubit.getShoppingList(home: home, translator: translator);
    }
  }
}
