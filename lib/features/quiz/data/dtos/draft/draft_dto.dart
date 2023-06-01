// ignore_for_file: overridden_fields, must_be_immutable

import 'package:hive_flutter/adapters.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import '../../../../../core/globals.dart';
import '../question/question_dto.dart';
part 'draft_dto.g.dart';

@HiveType(typeId: 5)
class DraftDto with HiveObjectMixin {
  static const hiveBoxName = 'drafts';
  @HiveField(0)
  final String id;

  @override
  get key => id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final bool isPublic;

  @HiveField(3)
  final String creatorId;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final List<QuestionDto> questions;

  @HiveField(6)
  final String? lesson;

  DraftDto({
    required this.lesson,
    required this.questions,
    required this.title,
    required this.isPublic,
    required this.creatorId,
    required this.imageUrl,
    required this.id,
  });

  static const titleField = 'title';
  static const isPublicField = 'isPublic';
  static const creatorField = 'creator';
  static const imageField = 'image';
  static const idField = 'id';
  static const questionsField = 'questions';
  static const lessonField = 'lesson';
  Map<dynamic, dynamic> toMap() {
    return {
      titleField: title,
      isPublicField: isPublic,
      creatorField: creatorId,
      imageField: imageUrl,
      idField: id,
      questionsField: questions.map((e) => e.toMap()),
    };
  }

  Map<String, dynamic> toStringMap() {
    return {
      lessonField: lesson,
      titleField: title,
      isPublicField: isPublic,
      creatorField: creatorId,
      imageField: imageUrl,
      idField: id,
      questionsField: questions.map((e) => e.toMap()),
    };
  }

  DraftEntity toEntity() {
    return DraftEntity(
        lesson: lesson,
        questions: questions.map((e) => e.toEntity()).toList(),
        title: title,
        isPublic: isPublic,
        creatorId: creatorId,
        imageUrl: imageUrl,
        id: id);
  }

  factory DraftDto.fromMap(Map<dynamic, dynamic> map) {
    return DraftDto(
      lesson: map[lessonField],
      questions: (map[questionsField] as List<Map<dynamic, dynamic>>)
          .map((e) => QuestionDto.fromMap(map[questionsField]))
          .toList(),
      title: map[titleField],
      isPublic: map[isPublicField],
      creatorId: map[creatorField],
      imageUrl: map[imageField],
      id: map[idField],
    );
  }

  factory DraftDto.fromEntity(DraftEntity entity) {
    return DraftDto(
      lesson: entity.lesson,
      creatorId: entity.creatorId,
      id: entity.id,
      imageUrl: entity.imageUrl,
      isPublic: entity.isPublic,
      questions:
          entity.questions.map((e) => QuestionDto.fromEntity(e)).toList(),
      title: entity.title,
    );
  }

  DraftDto copyWith({
    String? id,
    String? title = DefaultValues.forStrings,
    bool? isPublic,
    String? creatorId,
    String? imageUrl = DefaultValues.forStrings,
    List<QuestionDto>? questions,
    String? lesson,
  }) {
    return DraftDto(
      lesson: lesson ?? this.lesson,
      questions: questions ?? this.questions,
      isPublic: isPublic ?? this.isPublic,
      creatorId: creatorId ?? this.creatorId,
      id: id ?? this.id,
      title: title == DefaultValues.forStrings ? this.title : title,
      imageUrl: imageUrl == DefaultValues.forStrings ? this.imageUrl : imageUrl,
    );
  }
}
