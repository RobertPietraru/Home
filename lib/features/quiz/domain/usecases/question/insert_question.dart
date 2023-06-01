import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class InsertQuestionUsecase
    extends UseCase<InsertQuestionUsecaseResult, InsertQuestionUsecaseParams> {
  const InsertQuestionUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, InsertQuestionUsecaseResult>> call(params) async {
    return quizRepository.insertQuestion(params);
  }
}

class InsertQuestionUsecaseParams extends Params {
  final DraftEntity draft;
  final QuestionEntity question;
  final int index;
  const InsertQuestionUsecaseParams({
    required this.draft,
    required this.question,
    required this.index,
  });
}

class InsertQuestionUsecaseResult extends Response {
  final DraftEntity draft;
  const InsertQuestionUsecaseResult({required this.draft});
}
