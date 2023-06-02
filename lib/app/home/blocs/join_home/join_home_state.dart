part of 'join_home_cubit.dart';

enum JoinHomeStatus { loading, joined, error, idle }

class JoinHomeState extends Equatable {
  final HomeId homeId;
  final AppFailure? error;
  final JoinHomeStatus status;

  const JoinHomeState(
      {this.homeId = const HomeId.pure(),
      this.error,
      this.status = JoinHomeStatus.idle});

  @override
  List<Object?> get props => [homeId, error, status];

  bool get isSuccessful {
    return status == JoinHomeStatus.joined;
  }

  ValidationFailure? get validationFailure {
    return homeId.error;
  }

  String? get homeIdFailure => error?.message;

  JoinHomeState copyWith({
    HomeId? homeId,
    AppFailure? error = AppFailure.mockForDynamic,
    JoinHomeStatus? status,
  }) {
    return JoinHomeState(
      homeId: homeId ?? this.homeId,
      error: error == AppFailure.mockForDynamic ? this.error : error,
      status: status ?? this.status,
    );
  }
}
