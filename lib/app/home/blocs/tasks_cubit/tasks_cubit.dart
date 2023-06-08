import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../../core/failures/app_failure.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final HomeRepository homeRepository;
  final HomeEntity home;
  TaskType type;

  TasksCubit(
    this.homeRepository, {
    required this.type,
    required this.home,
  }) : super(const TasksState(
            tasks: [],
            filters: TaskFilters(sortFilters: [], showCompletedTasks: false)));

  void changeType(TaskType newType, Translator translator) {
    type = newType;
    getTasks(home: home, translator: translator);
  }

  Future<void> updateFilters(TaskFilters filters, Translator translator) async {
    emit(state.copyWith(filters: filters));
    await getTasks(home: home, translator: translator);
  }

  Future<void> getTasks({
    required HomeEntity home,
    required Translator translator,
  }) async {
    emit(state.copyWith(status: TasksStatus.loading));

    final choresResponse = await homeRepository.getTasks(
        GetTasksParams(homeId: home.id, type: type, filters: state.filters));

    choresResponse.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
    }, (r) {
      emit(state.copyWith(
        tasks: r.tasks,
        error: null,
        status: TasksStatus.loaded,
      ));
    });
  }

  Future<void> toggleTask(TaskEntity taskEntity, Translator translator) async {
    final index = state.tasks.indexOf(taskEntity);

    final TaskEntity? modifiedEntity = taskEntity.isCompleted
        ? await uncompleteTask(taskEntity, translator)
        : await completeTask(taskEntity, translator);
    // emit(state.copyWith(status: TasksStatus.loading));

    if (modifiedEntity == null) return;

    final newList = state.tasks.toList();
    newList[index] = modifiedEntity;
    emit(state.copyWith(
        tasks: newList, error: null, status: TasksStatus.loaded));
  }

  Future<TaskEntity?> completeTask(
      TaskEntity task, Translator translator) async {
    // emit(state.copyWith(status: TasksStatus.loading));

    final response =
        await homeRepository.completeTask(CompleteTaskParams(task: task));

    return response.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
      return null;
    }, (r) {
      return r.completedTask;
    });
  }

  Future<TaskEntity?> uncompleteTask(
      TaskEntity task, Translator translator) async {
    // emit(state.copyWith(status: TasksStatus.loading));

    final response =
        await homeRepository.uncompleteTask(UncompleteTaskParams(task: task));

    return response.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
      return null;
    }, (r) {
      return r.uncompletedTask;
    });
  }

  void addTaskToList(TaskEntity taskEntity) {
    emit(state.copyWith(tasks: [taskEntity, ...state.tasks]));
  }

  Future<void> deleteTask(TaskEntity entity, Translator translator) async {
    final response =
        await homeRepository.deleteTask(DeleteTaskParams(task: entity));

    response.fold((l) {
      emit(state.copyWith(
        error: AppFailure.fromTaskFailure(l, translator),
        status: TasksStatus.error,
      ));
      return;
    }, (r) {
      final list = state.tasks.toList();
      list.remove(entity);
      emit(
          state.copyWith(tasks: list, error: null, status: TasksStatus.loaded));
    });
  }

  Future<void> checkForMigration(HomeEntity home, Translator translator) async {
    final response = await homeRepository.needsMigration(home.id);
    await response.fold(
      (l) {
        emit(state.copyWith(
            status: TasksStatus.error,
            error: AppFailure.fromTaskFailure(l, translator)));
      },
      (needsMigration) async {
        if (needsMigration) {
          final response = await homeRepository.migrate(home.id);
          await response.fold(
            (l) {
              emit(
                state.copyWith(
                    error: AppFailure(
                        code: 'migration-failed',
                        message: translator.internalTaskError)),
              );
            },
            (r) async => await getTasks(home: home, translator: translator),
          );
        } else {
          await getTasks(home: home, translator: translator);
        }
      },
    );
  }
}
