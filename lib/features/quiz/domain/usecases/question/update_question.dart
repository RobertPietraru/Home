import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class UpdateQuestionUsecase
    extends UseCase<UpdateQuestionUsecaseResult, UpdateQuestionUsecaseParams> {
  const UpdateQuestionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, UpdateQuestionUsecaseResult>> call(params) async {
    return quizRepository.updateQuestion(params);
  }
}

class UpdateQuestionUsecaseParams extends Params {
  final DraftEntity draft;
  final QuestionEntity replacementQuestion;
  final int index;
  const UpdateQuestionUsecaseParams(
      {required this.draft,
      required this.replacementQuestion,
      required this.index});
}

class UpdateQuestionUsecaseResult extends Response {
  final DraftEntity quizEntity;
  const UpdateQuestionUsecaseResult({required this.quizEntity});
}
