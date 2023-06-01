import 'package:testador/features/quiz/domain/entities/draft_entity.dart';

import '../../../../../core/classes/usecase.dart';
import '../../failures/quiz_failures.dart';
import '../../repositories/quiz_repository.dart';

import 'package:dartz/dartz.dart';

class GetDraftByIdUsecase
    extends UseCase<GetDraftByIdUsecaseResult, GetDraftByIdUsecaseParams> {
  const GetDraftByIdUsecase(this.quizRepository);
  final QuizRepository quizRepository;
  @override
  Future<Either<QuizFailure, GetDraftByIdUsecaseResult>> call(params) async {
    return quizRepository.getDraftById(params);
  }
}

class GetDraftByIdUsecaseParams extends Params {
  final String quizId;
  const GetDraftByIdUsecaseParams({required this.quizId});
}

class GetDraftByIdUsecaseResult extends Response {
  final DraftEntity draft;
  const GetDraftByIdUsecaseResult({required this.draft});
}
