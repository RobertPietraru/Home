import 'package:dartz/dartz.dart';

import 'failure.dart';

abstract class UseCase<T, Params> {
  const UseCase();
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Params {}

// ignore: one_member_abstracts
abstract class Params {
  const Params();
}

abstract class Response {
  const Response();
}
