part of 'home_creation_cubit.dart';

enum HomeCreationStatus { loading, created, error, idle }

class HomeCreationState extends Equatable {
  final HomeName name;
  final HomeCreationStatus status;
  final AppFailure? failure;
  final bool usesWithSomeoneElse;
  final bool usesForChores;
  final bool usesForShoppingList;

  const HomeCreationState({
    this.name = const HomeName.pure(),
    required this.status,
    this.usesWithSomeoneElse = false,
    this.usesForChores = false,
    this.usesForShoppingList = false,
    this.failure,
  });

  @override
  List<Object?> get props => [
        name,
        status,
        usesWithSomeoneElse,
        usesForChores,
        usesForShoppingList,
        failure
      ];

  bool get isLoading {
    return status == HomeCreationStatus.loading;
  }

  bool get isSuccessful {
    return status == HomeCreationStatus.created;
  }

  ValidationFailure? get validationFailure {
    return name.error;
  }

  HomeCreationState copyWith({
    HomeName? name,
    HomeCreationStatus? status,
    AppFailure? failure = AppFailure.mockForDynamic,
    bool? usesWithSomeoneElse,
    bool? usesForChores,
    bool? usesForShoppingList,
  }) {
    return HomeCreationState(
      usesWithSomeoneElse: usesWithSomeoneElse ?? this.usesWithSomeoneElse,
      usesForChores: usesForChores ?? this.usesForChores,
      usesForShoppingList: usesForShoppingList ?? this.usesForShoppingList,
      name: name ?? this.name,
      status: status ?? this.status,
      failure: failure == AppFailure.mockForDynamic ? this.failure : failure,
    );
  }
}
