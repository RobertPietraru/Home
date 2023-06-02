import 'package:equatable/equatable.dart';

abstract class TaskFailure extends Equatable {
  final String code;
  const TaskFailure({required this.code});

  @override
  List<Object?> get props => [code];
}
