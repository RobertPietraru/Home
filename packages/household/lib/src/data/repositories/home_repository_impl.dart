import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:household/src/domain/failures/unknown_task_failure.dart';

import '../../domain/domain.dart';
import '../datasource/home_remote_data_source.dart';
import '../dtos/task_failure_dto.dart';

class HomeRepositoryIMPL implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryIMPL(this.homeRemoteDataSource);

  @override
  Future<Either<TaskFailure, CreateHomeResponse>> createHome(
      CreateHomeParams params) async {
    try {
      final response = await homeRemoteDataSource.createHome(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return const Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, DeleteHomeResponse>> deleteHome(
      DeleteHomeParams params) async {
    try {
      final response = await homeRemoteDataSource.deleteHome(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, GetHomesResponse>> getHomes(
      GetHomesParams params) async {
    try {
      final response = await homeRemoteDataSource.getHomes(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, InviteToHomeResponse>> inviteToHome(
      InviteToHomeParams params) async {
    try {
      final response = await homeRemoteDataSource.inviteToHome(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, JoinHomeResponse>> joinHome(
      JoinHomeParams params) async {
    try {
      final response = await homeRemoteDataSource.joinHome(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, CompleteTaskResponse>> completeTask(
      CompleteTaskParams params) async {
    try {
      final response = await homeRemoteDataSource.completeTask(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, GetTasksResponse>> getTasks(
      GetTasksParams params) async {
    try {
      final response = await homeRemoteDataSource.getTasks(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, UncompleteTaskResponse>> uncompleteTask(
      UncompleteTaskParams params) async {
    try {
      final response = await homeRemoteDataSource.uncompleteTask(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, CreateTaskResponse>> createTask(
      CreateTaskParams params) async {
    try {
      final response = await homeRemoteDataSource.createTask(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return const Left(UnknownTaskFailure());
    }
  }

  @override
  Future<Either<TaskFailure, DeleteTaskResponse>> deleteTask(
      DeleteTaskParams params) async {
    try {
      final response = await homeRemoteDataSource.deleteTask(params);
      return Right(response);
    } on TaskFailure catch (e) {
      return Left(e);
    } on FirebaseException catch (e) {
      return Left(TaskFailureDto.fromFirebaseException(e));
    } catch (e) {
      return const Left(UnknownTaskFailure());
    }
  }
}
