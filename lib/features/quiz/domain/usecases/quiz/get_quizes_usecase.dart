import 'package:equatable/equatable.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

class GetQuizesUsecase
    extends UseCase<GetQuizesUsecaseResult, GetQuizesUsecaseParams> {
  const GetQuizesUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, GetQuizesUsecaseResult>> call(params) async {
    return quizRepository.getQuizes(params);
  }
}

class GetQuizesUsecaseParams extends Params {
  final String creatorId;
  const GetQuizesUsecaseParams({required this.creatorId});
}

class GetQuizesUsecaseResult extends Response {
  final List<QuizDraftPair> pairs;
  const GetQuizesUsecaseResult({required this.pairs});
}

class QuizDraftPair extends Equatable {
  final QuizEntity quiz;
  final DraftEntity? draft;

  const QuizDraftPair({required this.quiz, this.draft});

  @override
  List<Object?> get props => [quiz, draft];
}
