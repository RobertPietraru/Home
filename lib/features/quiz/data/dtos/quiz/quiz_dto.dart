// ignore_for_file: overridden_fields, must_be_immutable

import 'package:hive_flutter/adapters.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';

import '../question/question_dto.dart';
part 'quiz_dto.g.dart';

@HiveType(typeId: 1)
class QuizDto with HiveObjectMixin {
  static const collection = 'quizes';
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
  final List<QuestionDto>? questions;

  @HiveField(6)
  final String? lesson;

  QuizDto({
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
      lessonField: lesson,
      titleField: title,
      isPublicField: isPublic,
      creatorField: creatorId,
      imageField: imageUrl,
      idField: id,
      questionsField: questions?.map((e) => e.toMap()),
    };
  }

  QuizEntity toEntity() {
    return QuizEntity(
        lesson: lesson,
        questions: (questions ?? []).map((e) => e.toEntity()).toList(),
        title: title,
        isPublic: isPublic,
        creatorId: creatorId,
        imageUrl: imageUrl,
        id: id);
  }

  factory QuizDto.fromMap(Map<dynamic, dynamic> map) {
    final x = (map[questionsField] as List);
    final y = x.map((e) => QuestionDto.fromMap(e));
    final z = y.toList();

    return QuizDto(
      lesson: map[lessonField],
      questions: z,
      title: map[titleField],
      isPublic: map[isPublicField],
      creatorId: map[creatorField],
      imageUrl: map[imageField],
      id: map[idField],
    );
  }

  factory QuizDto.fromEntity(QuizEntity entity) {
    return QuizDto(
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
}
