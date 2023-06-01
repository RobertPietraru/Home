import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';

class GenerationUnknownQuizFailure extends QuizFailure {
  final int status;
  GenerationUnknownQuizFailure({
    super.code = 'generation-unknown',
    required this.status,
  });

  @override
  String retrieveMessage(BuildContext context) {
    return '${context.translator.thereWasAnError} $code $status';
  }
}
