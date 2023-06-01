import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';

class PlayerNameAlreadyInUseQuizFailure extends QuizFailure {
  PlayerNameAlreadyInUseQuizFailure(
      {super.code = 'player-name-already-in-use'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.nameAlreadyUsed;
  }
}
