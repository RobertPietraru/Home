import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:household/src/domain/entities/tasks_entities.dart';

class HomeDto extends Equatable {
  final String id;
  final String name;
  final List<String> people;
  final List<String> admins;

  const HomeDto(
      {required this.id,
      required this.name,
      required this.people,
      required this.admins});

  static const String nameField = "name";
  static const String peopleField = "people";
  static const String adminsField = "admins";

  Map<String, dynamic> toSnapshotMap() {
    return {
      nameField: name,
      peopleField: people,
      adminsField: admins,
    };
  }

  HomeEntity toEntity() {
    return HomeEntity(id: id, name: name, people: people, admins: admins);
  }

  factory HomeDto.fromSnapshot(DocumentSnapshot snapshot) => HomeDto(
        name: snapshot[nameField],
        people: (snapshot[peopleField] as List<dynamic>).map((e) => "$e").toList(),
        admins:
            (snapshot[adminsField] as List<dynamic>).map((e) => "$e").toList(),
        id: snapshot.id,
      );

  @override
  List<Object?> get props => [id, name, people, admins];
}
