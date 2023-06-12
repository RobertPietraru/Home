import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';

class TaskDto {
  final DateTime creationDate;
  final String id;
  final String homeId;
  final String body;
  final DateTime? deadline;
  final bool isCompleted;
  final double importance;
  final TaskType type;

  const TaskDto({
    required this.homeId,
    required this.id,
    required this.body,
    required this.deadline,
    required this.isCompleted,
    required this.importance,
    required this.type,
    required this.creationDate,
  });
  static const String bodyField = 'body';
  static const String homeIdField = 'homeId';
  static const String deadlineField = 'deadline';
  static const String isCompletedField = 'isCompleted';
  static const String importanceField = 'importance';
  static const String typeField = 'type';
  static const String creationDateField = 'creationDate';

  Map<String, dynamic> toMap() {
    return {
      bodyField: body,
      homeIdField: homeId,
      deadlineField: deadline,
      isCompletedField: isCompleted,
      importanceField: importance,
      typeField: type.name,
      creationDateField: creationDate,
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
        creationDate: creationDate,
        homeId: homeId,
        type: type,
        id: id,
        body: body,
        deadline: deadline,
        isCompleted: isCompleted,
        importance: importance);
  }

  TaskDto copyWith({
    DateTime? creationDate,
    String? id,
    String? homeId,
    String? body,
    //TODO: find a way to  give this a default value
    DateTime? deadline,
    bool? isCompleted,
    double? importance,
    TaskType? type,
  }) {
    return TaskDto(
      homeId: homeId ?? this.homeId,
      id: id ?? this.id,
      body: body ?? this.body,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
      type: type ?? this.type,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  factory TaskDto.fromMap(Map<String, dynamic> map, String id) {
    return TaskDto(
      homeId: map[homeIdField],
      id: id,
      body: map[bodyField],
      deadline: map[deadlineField] == null
          ? null
          : (map[deadlineField] as Timestamp).toDate(),
      isCompleted: map[isCompletedField],
      importance: map[importanceField],
      type: TaskType.values
          .firstWhere((element) => map[typeField] == element.name),
      creationDate: ((map[creationDateField] as Timestamp?) ?? Timestamp.now()).toDate(),
    );
  }
}
