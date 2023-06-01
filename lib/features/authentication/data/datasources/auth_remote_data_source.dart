import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeapp/features/authentication/domain/failures/auth_failure.dart';

import '../../domain/auth_domain.dart';
import '../dtos/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> registerUser(RegisterParams params);
  Future<UserDto> loginUser(LoginParams params);
  Future<UserDto> getUserById(String id);
  Future<UserDto?> getLocalUser();
  Future<void> logUserOut();
}

class AuthFirebaseDataSourceIMPL implements AuthRemoteDataSource {
  AuthFirebaseDataSourceIMPL();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<UserDto> registerUser(RegisterParams params) async {
    final userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: params.email, password: params.password);

    final userId = userCredentials.user?.uid;
    if (userId == null) {
      throw const AuthUnknownFailure();
    }

    final userDto = UserDto(
      email: params.email,
      id: userId,
      name: params.name,
    );

    await firestore
        .collection('users')
        .doc(userId)
        .set(userDto.toSnapshotData());

    return userDto;
  }

  @override
  Future<UserDto> getUserById(String id) async {
    final document = await firestore.collection('users').doc(id).get();

    if (!document.exists) {
      await FirebaseAuth.instance.currentUser!.delete();
      throw const AuthUserNotFound();
    }

    return UserDto.fromSnapshot(document);
  }

  @override
  Future<UserDto> loginUser(LoginParams params) async {
    final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: params.email, password: params.password);

    final user = response.user;

    if (user == null) {
      throw const AuthUserNotFound();
    }
    return getUserById(user.uid);
  }

  @override
  Future<void> logUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserDto?> getLocalUser() async {
    final localUserId = FirebaseAuth.instance.currentUser?.uid;
    if (localUserId == null) {
      return null;
    }
    return getUserById(localUserId);
  }
}
