import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../../core/failures/app_failure.dart';
import '../../../../core/failures/validation_failure.dart';
import '../../validation/forms/task_title.dart';
import '../tasks_cubit/tasks_cubit.dart';
part 'task_creation_state.dart';

class TaskCreationCubit extends Cubit<TaskCreationState> {
  final HomeRepository homeRepository;
  final TasksCubit tasksCubit;
  TaskCreationCubit(
    this.homeRepository, {
    required this.tasksCubit,
  }) : super(const TaskCreationState());

  void titleChanged(String title) {
    final taskTitle = TaskTitle.dirty(title);
    emit(
      state.copyWith(
          body: taskTitle, status: TaskCreationStatus.idle, failure: null),
    );

    emit(state.copyWith(
      failure: null,
    ));
  }

  void deadlineChanged(DateTime deadline) {
    emit(state.copyWith(failure: null, deadline: deadline));
  }

  void importanceChanged(double newImportance) {
    emit(state.copyWith(failure: null, importance: newImportance));
  }

  Future<void> createTask({
    required String homeId,
    required String userId,
    required TaskType type,
    required Translator translator,
  }) async {
    if (state.validationFailure != null) {
      emit(state.copyWith(
        failure: AppFailure.fromValidationFailure(
            state.validationFailure!, translator),
        status: TaskCreationStatus.idle,
      ));
      return;
    }

    emit(state.copyWith(status: TaskCreationStatus.loading));

    final response = await homeRepository.createTask(CreateTaskParams(
      importance: state.importance,
      userId: userId,
      deadline: state.deadline,
      type: type,
      body: state.body.value,
      homeId: homeId,
    ));

    return response.fold((l) {
      emit(state.copyWith(
        failure: AppFailure.fromTaskFailure(l, translator),
        status: TaskCreationStatus.error,
      ));
    }, (r) {
      tasksCubit.addTaskToList(r.task);
      emit(state.copyWith(
        status: TaskCreationStatus.created,
        failure: null,
      ));
    });
  }
}
