import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:testador/features/quiz/data/dtos/draft/draft_dto.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/domain/usecases/draft/delete_draft_by_id.dart';
import 'package:uuid/uuid.dart';

import '../../domain/failures/quiz_failures.dart';
import '../../domain/usecases/quiz_usecases.dart';
import '../dtos/question/question_dto.dart';

abstract class QuizLocalDataSource {
  Future<DraftEntity> getDraftById(GetDraftByIdUsecaseParams params);
  Future<DraftEntity> moveQuestion(MoveQuestionUsecaseParams params);
  Future<DraftEntity> createDraft(CreateDraftUsecaseParams params);
  Future<DraftEntity> updateQuizImage(UpdateQuizImageUsecaseParams params);

  Future<DraftEntity> updateQuiz(UpdateQuizUsecaseParams params);
  Future<List<DraftEntity>> getDrafts(GetQuizesUsecaseParams params);
  Future<DraftEntity> insertQuestion(InsertQuestionUsecaseParams params);
  Future<DraftEntity> deleteQuestion(DeleteQuestionUsecaseParams params);
  Future<DraftEntity> updateQuestion(UpdateQuestionUsecaseParams params);
  Future<DraftEntity> updateQuestionImage(
      UpdateQuestionImageUsecaseParams params);

  Future<void> deleteDraftById(DeleteDraftByIdUsecaseParams params);
}

class QuizLocalDataSourceIMPL implements QuizLocalDataSource {
  QuizLocalDataSourceIMPL();

  final Box<DraftDto> draftsBox = Hive.box<DraftDto>(DraftDto.hiveBoxName);
  final storage = FirebaseStorage.instance;

  @override
  Future<DraftEntity> createDraft(CreateDraftUsecaseParams params) async {
    final id = const Uuid().v1();
    final draftDto = DraftDto(
      lesson: null,
      creatorId: params.creatorId,
      id: id,
      imageUrl: null,
      isPublic: false,
      title: null,
      questions: [
        QuestionDto(
          id: const Uuid().v1(),
          text: null,
          options: [
            const MultipleChoiceOptionDto(text: null, isCorrect: false),
            const MultipleChoiceOptionDto(text: null, isCorrect: false),
          ],
          quizId: id,
        )
      ],
    );
    draftsBox.put(id, draftDto);
    return draftDto.toEntity();
  }

  @override
  Future<DraftEntity> deleteQuestion(DeleteQuestionUsecaseParams params) async {
    final questions =
        params.draft.questions.map((e) => QuestionDto.fromEntity(e)).toList();

    questions.removeAt(params.index);

    final dto =
        DraftDto.fromEntity(params.draft).copyWith(questions: questions);
    draftsBox.put(dto.id, dto);
    return dto.toEntity();
  }

  @override
  Future<DraftEntity> insertQuestion(InsertQuestionUsecaseParams params) async {
    final questions =
        params.draft.questions.map((e) => QuestionDto.fromEntity(e)).toList();

    questions.insert(params.index, QuestionDto.fromEntity(params.question));

    final dto =
        DraftDto.fromEntity(params.draft).copyWith(questions: questions);

    draftsBox.put(dto.id, dto);
    return dto.toEntity();
  }

  @override
  Future<DraftEntity> updateQuestion(UpdateQuestionUsecaseParams params) async {
    var dto = DraftDto.fromEntity(params.draft);

    final questions = dto.questions.toList();
    questions[params.index] =
        QuestionDto.fromEntity(params.replacementQuestion);
    dto = dto.copyWith(questions: questions.toList());

    draftsBox.put(dto.id, dto);
    return dto.toEntity();
  }

  @override
  Future<DraftEntity> updateQuiz(UpdateQuizUsecaseParams params) async {
    draftsBox.put(params.quizId, DraftDto.fromEntity(params.quiz));
    return params.quiz;
  }

  @override
  Future<List<DraftEntity>> getDrafts(GetQuizesUsecaseParams params) async {
    return draftsBox.values
        .where((element) => element.creatorId == params.creatorId)
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<DraftEntity> getDraftById(GetDraftByIdUsecaseParams params) async {
    final quiz = draftsBox.get(params.quizId);
    if (quiz == null) {
      throw const QuizNotFoundFailure();
    }
    return quiz.toEntity();
  }

  @override
  Future<DraftEntity> moveQuestion(MoveQuestionUsecaseParams params) async {
    var dto = DraftDto.fromEntity(params.draft);
    final questions = dto.questions.toList();

    final question = questions[params.oldIndex];

    if (params.oldIndex < params.newIndex) {
      questions.insert(params.newIndex, question);
      questions.removeAt(params.oldIndex);
    } else {
      questions.removeAt(params.oldIndex);
      questions.insert(params.newIndex, question);
    }

    dto = dto.copyWith(questions: questions);
    draftsBox.put(dto.id, dto);
    return dto.toEntity();
  }

  @override
  Future<DraftEntity> updateQuestionImage(
      UpdateQuestionImageUsecaseParams params) async {
    var dto = DraftDto.fromEntity(params.draft);

    final questions = dto.questions.toList();
    String url = await uploadImage(
        params.draft.creatorId, params.draft.id, params.image);

    questions[params.index] = questions[params.index].copyWith(image: url);

    dto = dto.copyWith(questions: questions.toList());

    await draftsBox.put(dto.id, dto);
    return dto.toEntity();
  }

  Future<String> uploadImage(
      String creatorId, String quizId, XFile image) async {
    final fileExtension = basename(image.path).split('.').last;
    final path = '$creatorId/$quizId/${const Uuid().v1()}.$fileExtension';

    final snap = await storage.ref(path).putData(await image.readAsBytes());
    final url = await snap.ref.getDownloadURL();

    return url;
  }

  @override
  Future<DraftEntity> updateQuizImage(
      UpdateQuizImageUsecaseParams params) async {
    final imageUrl =
        await uploadImage(params.quiz.creatorId, params.quiz.id, params.image);
    final quiz = params.quiz.copyWith(imageUrl: imageUrl);
    draftsBox.put(quiz.id, DraftDto.fromEntity(quiz));
    return quiz;
  }

  @override
  Future<void> deleteDraftById(DeleteDraftByIdUsecaseParams params) async {
    await draftsBox.delete(params.draftId);
  }
}
