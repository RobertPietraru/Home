import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/cubit/homes_cubit.dart';
import 'package:homeapp/core/failures/app_failure.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../../core/failures/validation_failure.dart';
import '../../validation/forms/home_name.dart';
part 'home_creation_state.dart';

class HomeCreationCubit extends Cubit<HomeCreationState> {
  final HomeRepository homeRepository;
  final HomesCubit homesCubit;

  HomeCreationCubit(
    this.homeRepository, {
    required this.homesCubit,
  }) : super(const HomeCreationState(status: HomeCreationStatus.idle));

  void homeNameChanged(String newName) {
    final homeName = HomeName.dirty(newName);
    emit(
      state.copyWith(
          name: homeName, status: HomeCreationStatus.idle, failure: null),
    );
  }

  void updateCheckbox({
    bool? usesWithSomeoneElse,
    bool? usesForChores,
    bool? usesForShoppingList,
  }) {
    emit(state.copyWith(
      usesWithSomeoneElse: usesWithSomeoneElse,
      usesForChores: usesForChores,
      usesForShoppingList: usesForShoppingList,
      failure: null,
      status: HomeCreationStatus.error,
    ));
  }

  Future<void> createHome(String userId, Translator translator) async {
    if (state.validationFailure != null) {
      emit(state.copyWith(
        status: HomeCreationStatus.error,
        failure: AppFailure.fromTaskValidationFailure(
            state.validationFailure!, translator),
      ));
      return;
    }
    emit(state.copyWith(status: HomeCreationStatus.loading));

    final obj = await homeRepository
        .createHome(CreateHomeParams(name: state.name.value, userId: userId));

    return obj.fold((l) {
      emit(state.copyWith(
          failure: AppFailure.fromTaskFailure(l, translator),
          status: HomeCreationStatus.error));
    }, (r) {
      homesCubit.addHome(homeEntity: r.homeEntity);
      emit(state.copyWith(
        status: HomeCreationStatus.created,
        failure: null,
      ));
    });
  }
}
