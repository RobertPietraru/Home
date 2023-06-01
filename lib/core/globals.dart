import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';

class DefaultValues {
  static const String forStrings = 'nothing-to-see-here!@#^';
  // bad approach for complex projects, but here, where usually ints are just indexes of questions and stuff, it's not actually that bad
  static const int forInts = -6969696969;
  static const QuizFailure forQuizfailure = QuizUnknownFailure(code: 'mock');
}
