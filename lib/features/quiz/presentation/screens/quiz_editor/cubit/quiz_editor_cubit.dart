import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/failures/quiz_editor/deleting_the_only_question_failure.dart';
import 'package:testador/features/quiz/domain/failures/quiz_editor/need_question_to_generate.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/usecases/draft/delete_draft_by_id.dart';
import 'package:testador/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:uuid/uuid.dart';

import '../../quiz_list/cubit/quiz_list_cubit.dart';

part 'quiz_editor_state.dart';

class QuizEditorCubit extends Cubit<QuizEditorState> {
  final InsertQuestionUsecase insertQuestionUsecase;
  final UpdateQuestionUsecase updateQuestionUsecase;
  final DeleteQuestionUsecase deleteQuestionUsecase;
  final UpdateQuestionImageUsecase updateQuestionImageUsecase;
  final MoveQuestionUsecase moveQuestionUsecase;
  final UpdateQuizImageUsecase updateQuizImageUsecase;
  final UpdateQuizUsecase editQuizUsecase;
  final SyncQuizUsecase syncQuizUsecase;
  final DeleteDraftByIdUsecase deleteDraftByIdUsecase;
  final SuggestOptionsUsecase suggestOptionsUsecase;

  final QuizListCubit? quizListCubit;

  QuizEditorCubit(
    this.syncQuizUsecase,
    this.insertQuestionUsecase,
    this.updateQuestionUsecase,
    this.deleteQuestionUsecase,
    this.updateQuestionImageUsecase,
    this.moveQuestionUsecase,
    this.updateQuizImageUsecase,
    this.editQuizUsecase,
    this.deleteDraftByIdUsecase,
    this.suggestOptionsUsecase, {
    required QuizEntity initialQuiz,
    DraftEntity? initialDraft,
    required this.quizListCubit,
  }) : super(QuizEditorState(
            currentQuestionIndex: 0,
            lastSavedQuiz: initialQuiz,
            draft: initialDraft ?? DraftEntity.fromEntity(initialQuiz),
            failure: null,
            status: QuizEditorStatus.loaded));

  void navigateToIndex(int index) {
    emit(state.copyWith(currentQuestionIndex: index));
  }

  Future<void> insertQuestion(
      {required int index, required QuestionEntity question}) async {
    emit(state.copyWith(
        status: QuizEditorStatus.loading, failure: null, updateError: true));
    final response =
        await insertQuestionUsecase.call(InsertQuestionUsecaseParams(
      draft: state.draft,
      question: question,
      index: index,
    ));
    response.fold(
      (l) => emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      )),
      (r) => emit(state.copyWith(
          failure: null,
          status: QuizEditorStatus.loaded,
          updateError: true,
          draft: r.draft,
          currentQuestionIndex: index)),
    );
  }

  Future<void> addNewQuestion() async {
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));
    final response = await insertQuestionUsecase.call(
      InsertQuestionUsecaseParams(
        draft: state.draft,
        question: QuestionEntity(
          id: const Uuid().v1(),
          quizId: state.draft.id,
          options: const [
            MultipleChoiceOptionEntity(text: null),
            MultipleChoiceOptionEntity(text: null)
          ],
          text: null,
          image: null,
        ),
        index: state.currentQuestionIndex + 1,
      ),
    );
    response.fold(
      (l) => emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      )),
      (r) => emit(state.copyWith(
          failure: null,
          status: QuizEditorStatus.loaded,
          updateError: true,
          draft: r.draft,
          currentQuestionIndex: state.currentQuestionIndex + 1)),
    );
  }

  Future<void> addAnotherRowOfOptions({
    required int questionIndex,
  }) async {
    final question = state.currentQuestion;
    if (question.options.length >= 4) {
      //TODO error message
      return;
    }
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));

    final response =
        await updateQuestionUsecase.call(UpdateQuestionUsecaseParams(
      draft: state.draft,
      replacementQuestion: question.copyWith(options: [
        ...question.options,
        const MultipleChoiceOptionEntity(text: null),
        const MultipleChoiceOptionEntity(text: null),
      ]),
      index: questionIndex,
    ));

    response.fold(
      (l) => emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      )),
      (r) => emit(state.copyWith(
        failure: null,
        status: QuizEditorStatus.loaded,
        updateError: true,
        draft: r.quizEntity,
      )),
    );
  }

  Future<void> removeRowOfOptions({
    required int questionIndex,
  }) async {
    final question = state.currentQuestion;
    if (question.options.length <= 2) {
      //TODO error message
      return;
    }
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));
    final questions = question.options.toList();
    questions.removeLast();
    questions.removeLast();

    final response =
        await updateQuestionUsecase.call(UpdateQuestionUsecaseParams(
      draft: state.draft,
      replacementQuestion: state.currentQuestion.copyWith(options: questions),
      index: questionIndex,
    ));

    response.fold(
      (l) => emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      )),
      (r) => emit(state.copyWith(
        failure: null,
        status: QuizEditorStatus.loaded,
        updateError: true,
        draft: r.quizEntity,
      )),
    );
  }

  Future<void> deleteQuestion({required int index}) async {
    int newIndex = index;
    // if we'ere deleting the only question, stop
    if (state.draft.questions.length == 1) {
      emit(state.copyWith(
        updateError: true,
        failure: DeletingTheOnlyQuestionQuizFailure(),
        status: QuizEditorStatus.failed,
      ));
      return;
    }
    // if we're deleting the current question and it's the last one, we can't leave the same index cause it will be out of bounds
    // we subtract one
    if (state.draft.questions.length - 1 == index) {
      newIndex = index - 1;
    }

    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));
    final response = await deleteQuestionUsecase
        .call(DeleteQuestionUsecaseParams(draft: state.draft, index: index));
    response.fold(
      (l) => emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      )),
      (r) => emit(state.copyWith(
        failure: null,
        status: QuizEditorStatus.loaded,
        draft: r.quizEntity,
        currentQuestionIndex: newIndex,
      )),
    );
  }

  Future<void> updateQuestion(
      {required int index, required QuestionEntity replacementQuestion}) async {
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));

    final response = await updateQuestionUsecase.call(
        UpdateQuestionUsecaseParams(
            draft: state.draft,
            index: index,
            replacementQuestion: replacementQuestion));

    response.fold(
      (l) => emit(state.copyWith(
          failure: l, status: QuizEditorStatus.failed, updateError: true)),
      (r) {
        emit(state.copyWith(
            failure: null,
            status: QuizEditorStatus.loaded,
            draft: r.quizEntity,
            currentQuestionIndex: index));
      },
    );
  }

  Future<void> updateCurrentQuestionOption(
      {required int optionIndex,
      required MultipleChoiceOptionEntity newOption}) async {
    final question = state.currentQuestion;
    final options = question.options.toList();
    options[optionIndex] = newOption;
    await updateQuestion(
        index: state.currentQuestionIndex,
        replacementQuestion: question.copyWith(options: options));
  }

  Future<void> updateCurrentQuestionText({required String? newText}) async =>
      await updateQuestion(
        index: state.currentQuestionIndex,
        replacementQuestion: state.currentQuestion.copyWith(
          text: newText,
        ),
      );

  Future<void> updateQuestionImage({required XFile image}) async {
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));
    final response = await updateQuestionImageUsecase.call(
        UpdateQuestionImageUsecaseParams(
            draft: state.draft,
            image: image,
            index: state.currentQuestionIndex));
    response.fold(
      (l) {
        emit(state.copyWith(
          failure: l,
          status: QuizEditorStatus.failed,
          updateError: true,
        ));
      },
      (r) {
        emit(state.copyWith(
            failure: null, status: QuizEditorStatus.loaded, draft: r.quiz));
      },
    );
  }

  Future<void> moveQuestion(
      {required int oldIndex, required int newIndex}) async {
    emit(state.copyWith(status: QuizEditorStatus.loading, failure: null));
    final response = await moveQuestionUsecase.call(MoveQuestionUsecaseParams(
        newIndex: newIndex, oldIndex: oldIndex, draft: state.draft));

    response.fold(
      (l) {
        emit(state.copyWith(
          failure: l,
          status: QuizEditorStatus.failed,
          updateError: true,
        ));
      },
      (r) {
        emit(state.copyWith(
          failure: null,
          status: QuizEditorStatus.loaded,
          draft: r.quiz,
          currentQuestionIndex: r.quiz.questions.indexOf(state.currentQuestion),
          updateError: true,
        ));
      },
    );
  }

  Future<void> updateQuizImage({required XFile newImage}) async {
    emit(state.copyWith(
        status: QuizEditorStatus.loading, failure: null, updateError: true));

    final response = await updateQuizImageUsecase
        .call(UpdateQuizImageUsecaseParams(quiz: state.draft, image: newImage));

    response.fold(
      (l) {
        emit(state.copyWith(
            failure: l, status: QuizEditorStatus.failed, updateError: true));
      },
      (r) {
        emit(state.copyWith(
            failure: null,
            status: QuizEditorStatus.loaded,
            draft: r.quiz,
            updateError: true));
      },
    );
  }

  Future<void> togglePublicity() async {
    emit(state.copyWith(
        status: QuizEditorStatus.loading, failure: null, updateError: true));

    final response = await editQuizUsecase.call(UpdateQuizUsecaseParams(
        quiz: state.draft.copyWith(isPublic: !state.draft.isPublic),
        quizId: state.draft.id));

    response.fold(
      (l) => emit(state.copyWith(
          failure: l, status: QuizEditorStatus.failed, updateError: true)),
      (r) => emit(state.copyWith(
          failure: null,
          status: QuizEditorStatus.loaded,
          draft: r.quiz,
          updateError: true)),
    );
  }

  Future<void> updateQuiz({
    required String title,
    required String lesson,
  }) async {
    emit(state.copyWith(
        status: QuizEditorStatus.loading, failure: null, updateError: true));

    final response = await editQuizUsecase.call(UpdateQuizUsecaseParams(
        quiz: state.draft.copyWith(
          title: title,
          lesson: lesson,
        ),
        quizId: state.draft.id));

    response.fold(
      (l) => emit(state.copyWith(
          failure: l, status: QuizEditorStatus.failed, updateError: true)),
      (r) => emit(state.copyWith(
          failure: null,
          status: QuizEditorStatus.loaded,
          draft: r.quiz,
          updateError: true)),
    );
  }

  Future<void> save() async {
    emit(state.copyWith(
        status: QuizEditorStatus.loading, failure: null, updateError: true));
    final response =
        await syncQuizUsecase.call(SyncQuizUsecaseParams(draft: state.draft));
    response.fold((l) {
      emit(state.copyWith(
        failure: l,
        status: QuizEditorStatus.failed,
        updateError: true,
      ));
    }, (r) {
      quizListCubit?.updateQuiz(draft: state.draft);
      emit(state.copyWith(
        failure: null,
        status: QuizEditorStatus.loaded,
        lastSavedQuiz: state.draft.toQuiz(),
        updateError: true,
      ));
    });
  }

  void deleteDraft() async {
    await deleteDraftByIdUsecase
        .call(DeleteDraftByIdUsecaseParams(draftId: state.draft.id));
    quizListCubit?.removeDraft(state.draft);
  }

  Future<void> suggestOptions() async {
    if (state.currentQuestion.text == null) {
      emit(state.copyWith(
          failure: NeedQuestionToGenerateQuizFailure(),
          status: QuizEditorStatus.failed,
          updateError: true));
      return;
    }

    emit(state.copyWith(
      failure: null,
      status: QuizEditorStatus.loading,
      updateError: true,
    ));
    final response = await suggestOptionsUsecase.call(
      SuggestOptionsUsecaseParams(
          questionIndex: state.currentQuestionIndex, draft: state.draft),
    );
    response.fold((l) {
      emit(state.copyWith(
          failure: l, updateError: true, status: QuizEditorStatus.failed));
    }, (r) {
      emit(state.copyWith(
          failure: null,
          draft: r.draft,
          updateError: true,
          status: QuizEditorStatus.loaded));
    });
  }
}
