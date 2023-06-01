import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import '../../failures/quiz_failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/classes/usecase.dart';
import '../../repositories/quiz_repository.dart';

class UpdateQuizImageUsecase extends UseCase<UpdateQuizImageUsecaseResult,
    UpdateQuizImageUsecaseParams> {
  const UpdateQuizImageUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, UpdateQuizImageUsecaseResult>> call(params) async {
    return quizRepository.updateQuizImage(params);
  }
}

class UpdateQuizImageUsecaseParams extends Params {
  final DraftEntity quiz;
  final XFile image;
  const UpdateQuizImageUsecaseParams({required this.quiz, required this.image});
}

class UpdateQuizImageUsecaseResult extends Response {
  final DraftEntity quiz;
  const UpdateQuizImageUsecaseResult({required this.quiz});
}
