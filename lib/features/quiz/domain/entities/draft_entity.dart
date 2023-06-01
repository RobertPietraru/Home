import 'package:equatable/equatable.dart';
import 'package:testador/core/globals.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';

class DraftEntity extends Equatable {
  final String id;
  final String? title;
  final bool isPublic;
  final String creatorId;
  final String? imageUrl;
  final List<QuestionEntity> questions;
  final String? lesson;

  const DraftEntity({
    required this.lesson,
    required this.questions,
    required this.title,
    required this.isPublic,
    required this.creatorId,
    required this.imageUrl,
    required this.id,
  });

  factory DraftEntity.fromEntity(QuizEntity quiz) {
    return DraftEntity(
      lesson: quiz.lesson,
      questions: quiz.questions,
      title: quiz.title,
      isPublic: quiz.isPublic,
      creatorId: quiz.creatorId,
      imageUrl: quiz.imageUrl,
      id: quiz.id,
    );
  }
  @override
  List<Object?> get props =>
      [id, lesson, title, isPublic, creatorId, imageUrl, ...questions];
  DraftEntity copyWith({
    String? id,
    String? title = DefaultValues.forStrings,
    bool? isPublic,
    String? creatorId,
    String? imageUrl = DefaultValues.forStrings,
    List<QuestionEntity>? questions,
    String? lesson = DefaultValues.forStrings,
  }) {
    return DraftEntity(
      lesson: DefaultValues.forStrings == lesson ? this.lesson : lesson,
      questions: questions ?? this.questions,
      isPublic: isPublic ?? this.isPublic,
      creatorId: creatorId ?? this.creatorId,
      id: id ?? this.id,
      title: title == DefaultValues.forStrings ? this.title : title,
      imageUrl: imageUrl == DefaultValues.forStrings ? this.imageUrl : imageUrl,
    );
  }

  QuizEntity toQuiz() {
    return QuizEntity(
      lesson: lesson,
      questions: questions,
      title: title,
      isPublic: isPublic,
      creatorId: creatorId,
      imageUrl: imageUrl,
      id: id,
    );
  }
}
