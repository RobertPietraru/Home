import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';

class GenerationInCooldownQuizFailure extends QuizFailure {
  GenerationInCooldownQuizFailure({super.code = 'generation-in-cooldown'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.yourQuizOnlyHasOne;
  }
}
