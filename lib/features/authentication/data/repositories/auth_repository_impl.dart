import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/auth_domain.dart';
import '../../domain/failures/auth_failure.dart';
import '../datasources/auth_remote_data_source.dart';
import '../dtos/auth_failure_dto.dart';

class AuthRepositoryIMPL implements AuthRepository {
  const AuthRepositoryIMPL(
    this.authRemoteDataSource,
  );

  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<AuthFailure, UserEntity>> registerUser(
      RegisterParams params) async {
    try {
      final userEntity = await authRemoteDataSource.registerUser(params);
      return Right(userEntity);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailureDto.fromFirebaseErrorCode(e.code));
    } on AuthFailure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(AuthUnknownFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> loginUser(LoginParams params) async {
    try {
      final entity = await authRemoteDataSource.loginUser(params);
      return Right(entity);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailureDto.fromFirebaseErrorCode(e.code));
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(AuthUnknownFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> getUserById(String id) async {
    try {
      final entity = await authRemoteDataSource.getUserById(id);
      return Right(entity);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailureDto.fromFirebaseErrorCode(e.code));
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(AuthUnknownFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> logUserOut() async {
    try {
      final response = await authRemoteDataSource.logUserOut();
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailureDto.fromFirebaseErrorCode(e.code));
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(AuthUnknownFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getLocalUser() async {
    try {
      final entity = await authRemoteDataSource.getLocalUser();
      return Right(entity);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailureDto.fromFirebaseErrorCode(e.code));
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(AuthUnknownFailure());
    }
  }
}
