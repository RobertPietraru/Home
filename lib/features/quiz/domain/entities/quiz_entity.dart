import 'package:equatable/equatable.dart';
import 'package:testador/core/globals.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';

class QuizEntity extends Equatable {
  final String id;
  final String? title;
  final bool isPublic;
  final String creatorId;
  final String? imageUrl;
  final List<QuestionEntity> questions;
  final String? lesson;

  const QuizEntity({
    required this.lesson,
    required this.questions,
    required this.title,
    required this.isPublic,
    required this.creatorId,
    required this.imageUrl,
    required this.id,
  });

  @override
  List<Object?> get props =>
      [id, lesson, title, isPublic, creatorId, imageUrl, ...questions];
  QuizEntity copyWith({
    String? id,
    String? title = DefaultValues.forStrings,
    bool? isPublic,
    String? creatorId,
    String? imageUrl = DefaultValues.forStrings,
    List<QuestionEntity>? questions,
    String? lesson,
  }) {
    return QuizEntity(
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
