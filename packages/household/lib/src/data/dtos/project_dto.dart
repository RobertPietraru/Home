import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';

class ProjectDto extends Equatable {
  final String id;
  final String homeId;
  final List<String> taskIds;
  final String title;
  final String description;
  final DateTime creationDate;

  const ProjectDto(
      {required this.id,
      required this.homeId,
      required this.taskIds,
      required this.title,
      required this.description,
      required this.creationDate});

  static const String homeIdField = 'homeId';
  static const String taskIdsField = 'taskIds';
  static const String titleField = 'title';
  static const String descriptionField = 'description';
  static const String creationDateField = 'creationDate';

  ProjectDto copyWith({
    String? id,
    String? homeId,
    List<String>? taskIds,
    String? title,
    String? description,
    DateTime? creationDate,
  }) {
    return ProjectDto(
      id: id ?? this.id,
      homeId: homeId ?? this.homeId,
      taskIds: taskIds ?? this.taskIds,
      title: title ?? this.title,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  factory ProjectDto.fromMap(Map<String, dynamic> map, String id) {
    return ProjectDto(
      id: id,
      homeId: map[homeIdField],
      taskIds: (map[taskIdsField] as List<dynamic>).map((e) => "$e").toList(),
      title: map[titleField],
      description: map[descriptionField],
      creationDate:
          ((map[creationDateField] as Timestamp?) ?? Timestamp.now()).toDate(),
    );
  }

  @override
  List<Object?> get props =>
      [id, homeId, title, description, creationDate, ...taskIds];

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      homeId: homeId,
      taskIds: taskIds,
      title: title,
      description: description,
      creationDate: creationDate,
    );
  }
}
