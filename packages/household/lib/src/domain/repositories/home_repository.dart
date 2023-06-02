import 'package:dartz/dartz.dart';
import '../entities/home_entity.dart';
import '../entities/tasks_entities.dart';
import '../failures/task_failure.dart';

abstract class HomeRepository {
  Future<Either<TaskFailure, GetHomesResponse>> getHomes(GetHomesParams params);
  Future<Either<TaskFailure, DeleteHomeResponse>> deleteHome(
      DeleteHomeParams params);
  Future<Either<TaskFailure, CreateHomeResponse>> createHome(
      CreateHomeParams params);
  Future<Either<TaskFailure, InviteToHomeResponse>> inviteToHome(
      InviteToHomeParams params);
  Future<Either<TaskFailure, JoinHomeResponse>> joinHome(JoinHomeParams params);

  Future<Either<TaskFailure, GetTasksResponse>> getTasks(GetTasksParams params);
  Future<Either<TaskFailure, CreateTaskResponse>> createTask(
      CreateTaskParams params);
  Future<Either<TaskFailure, DeleteTaskResponse>> deleteTask(
      DeleteTaskParams params);
  Future<Either<TaskFailure, CompleteTaskResponse>> completeTask(
      CompleteTaskParams params);
  Future<Either<TaskFailure, UncompleteTaskResponse>> uncompleteTask(
      UncompleteTaskParams params);
}

class CreateHomeParams {
  final String name;
  final String userId;

  const CreateHomeParams({required this.name, required this.userId});
}

class CreateHomeResponse {
  final HomeEntity homeEntity;

  const CreateHomeResponse({required this.homeEntity});
}

class DeleteHomeParams {
  final String homeId;

  const DeleteHomeParams({required this.homeId});
}

class DeleteHomeResponse {
  const DeleteHomeResponse();
}

class GetHomesParams {
  final String userId;

  const GetHomesParams({required this.userId});
}

class GetHomesResponse {
  final List<HomeEntity> homes;

  const GetHomesResponse({required this.homes});
}

class InviteToHomeParams {
  final String homeId;
  const InviteToHomeParams({required this.homeId});
}

class InviteToHomeResponse {
  final HomeEntity home;

  const InviteToHomeResponse({required this.home});
}

class JoinHomeParams {
  final String homeId;
  final String userId;

  const JoinHomeParams({required this.userId, required this.homeId});
}

class JoinHomeResponse {
  final HomeEntity joinedHome;

  const JoinHomeResponse({required this.joinedHome});
}

class CompleteTaskParams {
  final TaskEntity task;

  const CompleteTaskParams({required this.task});
}

class CompleteTaskResponse {
  final TaskEntity completedTask;

  const CompleteTaskResponse({required this.completedTask});
}

class CreateTaskParams {
  final String userId;
  final TaskType type;
  final String body;
  final String homeId;
  final DateTime? deadline;
  final double importance;

  const CreateTaskParams(
      {required this.importance,
      required this.userId,
      required this.deadline,
      required this.type,
      required this.body,
      required this.homeId});
}

class CreateTaskResponse {
  final TaskEntity task;

  const CreateTaskResponse({required this.task});
}

class DeleteTaskParams {
  final TaskEntity task;

  const DeleteTaskParams({required this.task});
}

class DeleteTaskResponse {
  const DeleteTaskResponse();
}

/// Tasks Stuff

class GetTasksParams {
  final String homeId;
  final TaskType type;

  const GetTasksParams({required this.homeId, required this.type});
}

class GetTasksResponse {
  final List<TaskEntity> tasks;

  GetTasksResponse({required this.tasks});
}

class UncompleteTaskParams {
  final TaskEntity task;

  const UncompleteTaskParams({required this.task});
}

class UncompleteTaskResponse {
  final TaskEntity uncompletedTask;

  const UncompleteTaskResponse({required this.uncompletedTask});
}
