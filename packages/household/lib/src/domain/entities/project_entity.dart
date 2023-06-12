import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String homeId;
  final List<String> taskIds;
  final String title;
  final String description;
  final DateTime creationDate;

  const ProjectEntity(
      {required this.id,
      required this.homeId,
      required this.taskIds,
      required this.title,
      required this.description,
      required this.creationDate});

  ProjectEntity copyWith({
    String? id,
    String? homeId,
    List<String>? taskIds,
    String? title,
    String? description,
    DateTime? creationDate,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      homeId: homeId ?? this.homeId,
      taskIds: taskIds ?? this.taskIds,
      title: title ?? this.title,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  List<Object?> get props =>
      [id, homeId, title, description, creationDate, ...taskIds];
}