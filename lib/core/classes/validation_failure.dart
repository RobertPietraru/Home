import 'package:equatable/equatable.dart';

class ValidationFailure extends Equatable {
  final String code;

  const ValidationFailure({required this.code});

  @override
  List<Object?> get props => [code];
}
