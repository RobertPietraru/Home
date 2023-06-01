import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';

class NeedQuestionToGenerateQuizFailure extends QuizFailure {
  NeedQuestionToGenerateQuizFailure({super.code = 'need-question-to-generate'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.needQuestionToGenerate;
  }
}
