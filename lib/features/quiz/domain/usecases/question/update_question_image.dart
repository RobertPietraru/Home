import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class UpdateQuestionImageUsecase extends UseCase<
    UpdateQuestionImageUsecaseResult, UpdateQuestionImageUsecaseParams> {
  const UpdateQuestionImageUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, UpdateQuestionImageUsecaseResult>> call(
      params) async {
    return quizRepository.updateQuestionImage(params);
  }
}

class UpdateQuestionImageUsecaseParams extends Params {
  final DraftEntity draft;
  final int index;
  final XFile image;
  const UpdateQuestionImageUsecaseParams(
      {required this.image, required this.draft, required this.index});
}

class UpdateQuestionImageUsecaseResult extends Response {
  final DraftEntity quiz;
  const UpdateQuestionImageUsecaseResult({required this.quiz});
}
