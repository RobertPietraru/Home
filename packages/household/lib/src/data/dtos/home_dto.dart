import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';

class HomeDto extends HomeEntity {
  const HomeDto(
      {required super.id,
      required super.name,
      required super.people,
      required super.admins});

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

  factory HomeDto.fromSnapshot(DocumentSnapshot snapshot) => HomeDto(
        name: snapshot[nameField],
        people:
            (snapshot[peopleField] as List<dynamic>).map((e) => "$e").toList(),
        admins:
            (snapshot[adminsField] as List<dynamic>).map((e) => "$e").toList(),
        id: snapshot.id,
      );
}
