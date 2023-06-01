import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';

import '../quiz_failures.dart';

class SessionNotFoundFailure extends QuizFailure {
  const SessionNotFoundFailure({super.code = 'session-not-found'});

  @override
  String retrieveMessage(BuildContext context) {
    return context.translator.sessionNotFound;
  }
}
