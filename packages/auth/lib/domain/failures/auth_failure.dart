import 'package:equatable/equatable.dart';


abstract class AuthFailure extends Equatable {
  final String code;

  const AuthFailure({required this.code});

  @override
  List<Object?> get props => [code];

}
