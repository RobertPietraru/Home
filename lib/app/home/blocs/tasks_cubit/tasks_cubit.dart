import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../../core/failures/app_failure.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final HomeRepository homeRepository;

  TasksCubit(
    this.homeRepository,
  ) : super(const TasksState(chores: [], shoppingList: []));

  Future<void> getChores(
      {required HomeEntity home, required Translator translator}) async {
    emit(state.copyWith(status: TasksStatus.loading));

    final choresResponse = await homeRepository
        .getTasks(GetTasksParams(homeId: home.id, type: TaskType.chore));

    choresResponse.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
    }, (r) {
      emit(state.copyWith(chores: r.tasks, status: TasksStatus.loaded));
    });
  }

  Future<void> toggleTask(TaskEntity taskEntity, Translator translator) async {
    final indexInChores = state.chores.indexOf(taskEntity);
    final indexInShoppingList = state.shoppingList.indexOf(taskEntity);

    late final TaskEntity? modifiedEntity;
    // emit(state.copyWith(status: TasksStatus.loading));

    if (taskEntity.isCompleted) {
      modifiedEntity = await uncompleteTask(taskEntity, translator);
    } else {
      modifiedEntity = await completeTask(taskEntity, translator);
    }

    if (modifiedEntity == null) {
      return;
    }

    if (modifiedEntity.type == TaskType.shopping) {
      final newList = state.shoppingList.toList();
      newList.removeAt(indexInShoppingList);
      newList.insert(indexInShoppingList, modifiedEntity);
      emit(state.copyWith(
          shoppingList: newList, error: null, status: TasksStatus.loaded));
    } else {
      final newList = state.chores.toList();
      newList.removeAt(indexInChores);
      newList.insert(indexInChores, modifiedEntity);
      emit(state.copyWith(
          chores: newList, error: null, status: TasksStatus.loaded));
    }
  }

  Future<TaskEntity?> completeTask(
      TaskEntity taskEntity, Translator translator) async {
    // emit(state.copyWith(status: TasksStatus.loading));

    final response =
        await homeRepository.completeTask(CompleteTaskParams(task: taskEntity));

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
      TaskEntity taskEntity, Translator translator) async {
    // emit(state.copyWith(status: TasksStatus.loading));

    final response = await homeRepository
        .uncompleteTask(UncompleteTaskParams(task: taskEntity));

    return response.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
      return null;
    }, (r) {
      return r.uncompletedTask;
    });
  }

  Future<void> getShoppingList(
      {required HomeEntity home, required Translator translator}) async {
    emit(state.copyWith(status: TasksStatus.loading));

    final choresResponse = await homeRepository
        .getTasks(GetTasksParams(homeId: home.id, type: TaskType.shopping));

    choresResponse.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
    }, (r) {
      emit(state.copyWith(shoppingList: r.tasks, status: TasksStatus.loaded));
    });
  }

  void addTask(TaskEntity taskEntity) {
    if (taskEntity.type == TaskType.chore) {
      emit(state.copyWith(chores: [taskEntity, ...state.chores]));
    } else {
      emit(state.copyWith(shoppingList: [taskEntity, ...state.shoppingList]));
    }
  }

  Future<void> getTasksForType(
      HomeEntity home, TaskType type, Translator translator) async {
    if (type == TaskType.chore) {
      await getChores(home: home, translator: translator);
    } else {
      await getShoppingList(home: home, translator: translator);
    }
  }

  Future<void> deleteTask(TaskEntity entity, Translator translator) async {
    final response =
        await homeRepository.deleteTask(DeleteTaskParams(task: entity));

    response.fold((l) {
      emit(state.copyWith(
          error: AppFailure.fromTaskFailure(l, translator),
          status: TasksStatus.error));
      return;
    }, (r) {
      if (entity.type == TaskType.chore) {
        final list = state.chores.toList();
        list.remove(entity);
        emit(state.copyWith(
            chores: list, error: null, status: TasksStatus.loaded));
      } else {
        final list = state.shoppingList.toList();
        list.remove(entity);
        emit(state.copyWith(
            shoppingList: list, error: null, status: TasksStatus.loaded));
      }
    });
  }
}
