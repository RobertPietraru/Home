import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/auth_domain.dart';


class UserDto extends UserEntity {
  const UserDto({
    required super.email,
    required super.id,
    required super.name,
  });

  factory UserDto.empty() {
    return const UserDto(
      email: null,
      id: 'qweasadfjqwerupp',
      name: '%%%%%%%%',
    );
  }

  factory UserDto.fromSnapshot(DocumentSnapshot snapshot) {
    return UserDto(
      id: snapshot.id,
      email: snapshot['email'] as String,
      name: snapshot['name'] as String,
    );
  }

  Map<dynamic, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
      };

  Map<String, dynamic> toSnapshotData() => {
        'email': email,
        'name': name,
      };
}
