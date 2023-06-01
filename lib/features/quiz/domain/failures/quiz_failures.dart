import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../core/classes/failure.dart';

abstract class QuizFailure extends Failure {
  const QuizFailure({required super.code});
  @override
  List<Object?> get props => [code];

  /// Returns the error message translated to the current language
  String retrieveMessage(BuildContext context);
}

class QuizNetworkFailure extends QuizFailure {
  const QuizNetworkFailure({super.code = 'network-request-failed'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.youAreNotConnected;
  }
}

class QuizNotFoundFailure extends QuizFailure {
  const QuizNotFoundFailure({super.code = 'quiz-not-found'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.quizNotFound;
  }
}

class QuizUnknownFailure extends QuizFailure {
  const QuizUnknownFailure({super.code = 'unknown'});

  @override
  String retrieveMessage(BuildContext context) {
    return '${context.translator.thereWasAnError} $code';
  }
}
