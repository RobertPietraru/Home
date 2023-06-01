import 'package:equatable/equatable.dart';

abstract class Failure with EquatableMixin {
  final String code;
  const Failure({required this.code});

  @override
  List<Object?> get props => [code];
}