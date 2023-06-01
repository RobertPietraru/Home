import 'package:equatable/equatable.dart';
import 'package:testador/core/globals.dart';

class QuestionEntity extends Equatable {
  final String id;
  final String quizId;
  final String? image;
  final String? text;
  final List<MultipleChoiceOptionEntity> options;
  bool get hasMultipleAnswers =>
      options.where((element) => element.isCorrect).length > 1;

  const QuestionEntity({
    required this.id,
    this.options = const [],
    required this.text,
    this.image,
    required this.quizId,
  });
  @override
  List<Object?> get props => [id, quizId, image, text, ...options];

  QuestionEntity copyWith({
    String? id,
    String? quizId,
    String? image = DefaultValues.forStrings,
    String? text = DefaultValues.forStrings,
    List<MultipleChoiceOptionEntity>? options,
  }) {
    return QuestionEntity(
      options: options ?? this.options,
      quizId: quizId ?? this.quizId,
      text: text == DefaultValues.forStrings ? this.text : text,
      image: image == DefaultValues.forStrings ? this.image : image,
      id: id ?? this.id,
    );
  }
}

class MultipleChoiceOptionEntity extends Equatable {
  final String? text;
  final bool isCorrect;
  const MultipleChoiceOptionEntity(
      {required this.text, this.isCorrect = false});
  @override
  List<Object?> get props => [text, isCorrect];
}
