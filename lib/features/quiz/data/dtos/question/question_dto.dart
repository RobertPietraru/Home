// ignore_for_file: overridden_fields

import 'package:hive_flutter/hive_flutter.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';

import '../../../../../core/globals.dart';
part "question_dto.g.dart";

@HiveType(typeId: 2)
class QuestionDto {
  @HiveField(1)
  final String quizId;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final List<MultipleChoiceOptionDto>? options;

  @HiveField(6)
  final String? text;

  @HiveField(7)
  final String id;
  static const quizIdField = 'quizId';
  static const typeField = 'type';
  static const imageField = 'image';
  static const optionsField = 'options';
  static const textField = 'text';
  static const idField = 'id';

  const QuestionDto({
    required this.id,
    required this.text,
    this.image,
    required this.options,
    required this.quizId,
  });

  factory QuestionDto.fromMap(Map<dynamic, dynamic> map) {
    final optionDtos = (map[optionsField] as List)
        .map((e) => MultipleChoiceOptionDto.fromMap(e))
        .toList();

    return QuestionDto(
      id: map[idField],
      text: map[textField],
      image: map[imageField],
      quizId: map[quizIdField],
      options: optionDtos,
    );
  }

  factory QuestionDto.fromEntity(QuestionEntity entity) {
    return QuestionDto(
      id: entity.id,
      text: entity.text,
      image: entity.image,
      options: entity.options
          .map((e) => MultipleChoiceOptionDto.fromEntity(e))
          .toList(),
      quizId: entity.quizId,
    );
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
        id: id,
        image: image,
        quizId: quizId,
        text: text,
        options: (options ?? []).map((e) => e.toEntity()).toList());
  }

  Map<dynamic, dynamic> toMap() {
    return {
      quizIdField: quizId,
      imageField: image,
      optionsField: options?.map((e) => e.toMap()).toList(),
      textField: text,
      idField: id,
    };
  }

  QuestionDto fromMap(Map<dynamic, dynamic> map) {
    return QuestionDto(
      quizId: map[quizIdField],
      image: map[imageField],
      options: (map[optionsField] as List<Map<dynamic, dynamic>>)
          .map((e) => MultipleChoiceOptionDto.fromMap(e))
          .toList(),
      text: map[textField],
      id: map[idField],
    );
  }

  QuestionDto copyWith({
    String? id,
    String? quizId,
    String? image = DefaultValues.forStrings,
    String? text = DefaultValues.forStrings,
    List<MultipleChoiceOptionDto>? options,
  }) {
    return QuestionDto(
      options: options ?? this.options,
      quizId: quizId ?? this.quizId,
      text: text == DefaultValues.forStrings ? this.text : text,
      image: image == DefaultValues.forStrings ? this.image : image,
      id: id ?? this.id,
    );
  }
}

@HiveType(typeId: 3)
class MultipleChoiceOptionDto {
  @HiveField(0)
  final String? text;

  @HiveField(1)
  final bool isCorrect;

  const MultipleChoiceOptionDto({
    required this.text,
    required this.isCorrect,
  });

  static const textField = 'text';
  static const isCorrectField = 'isCorrect';

  MultipleChoiceOptionEntity toEntity() {
    return MultipleChoiceOptionEntity(
      text: text,
      isCorrect: isCorrect,
    );
  }

  factory MultipleChoiceOptionDto.fromEntity(
      MultipleChoiceOptionEntity entity) {
    return MultipleChoiceOptionDto(
      text: entity.text,
      isCorrect: entity.isCorrect,
    );
  }

  factory MultipleChoiceOptionDto.fromMap(Map<dynamic, dynamic> map) {
    return MultipleChoiceOptionDto(
        text: map[textField], isCorrect: map[isCorrectField]);
  }

  Map<dynamic, dynamic> toMap() {
    return {
      textField: text,
      isCorrectField: isCorrect,
    };
  }
}
