import 'package:equatable/equatable.dart';

enum TaskType {
  chore,
  shopping,
}

class TaskEntity extends Equatable {
  final DateTime creationDate;
  final String id;
  final String homeId;
  final String body;
  final DateTime? deadline;
  final bool isCompleted;
  final double importance;
  final TaskType type;

  const TaskEntity(
      {required this.creationDate,
      required this.homeId,
      required this.type,
      required this.id,
      required this.body,
      required this.deadline,
      required this.isCompleted,
      required this.importance});

  @override
  List<Object?> get props => [body, deadline, isCompleted, importance, id];

  TaskEntity copyWith(
      {String? id,
      String? body,
      DateTime? deadline,
      bool? isCompleted,
      double? importance,
      String? homeId,
      TaskType? type,
      DateTime? creationDate}) {
    return TaskEntity(
      creationDate: creationDate ?? this.creationDate,
      type: type ?? this.type,
      homeId: homeId ?? this.homeId,
      id: id ?? this.id,
      body: body ?? this.body,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      importance: importance ?? this.importance,
    );
  }
}
