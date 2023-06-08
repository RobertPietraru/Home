part of 'homes_cubit.dart';

enum HomesStatus { initial, loading, retrieved, error }

class HomesState extends Equatable {
  final List<HomeEntity> homes;
  final AppFailure? failure;
  final HomesStatus status;
  
  const HomesState({
    required this.homes,
    this.failure,
    this.status = HomesStatus.initial,
  });
  HomeEntity get currentHome {
    return homes[0];
  }

  bool get isLoading {
    return status == HomesStatus.loading;
  }

  bool get isUninitialized {
    return status == HomesStatus.initial;
  }

  HomesState copyWith({
    List<HomeEntity>? homes,
    AppFailure? failure = AppFailure.mock,
    HomesStatus? status,
  }) {
    return HomesState(
      homes: homes ?? this.homes,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [homes, failure, status];
}
