
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.homeId,
    required this.id,
    this.email,
    required this.name,
  });

  final String? email;
  final String id;
  final String name;
  final String? homeId;
  @override
  List<Object?> get props => [email, id, name, homeId];
}
