import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/homes_cubit/homes_cubit.dart';
import 'package:homeapp/core/failures/app_failure.dart';
import 'package:household/household.dart';

import '../../../../core/failures/validation_failure.dart';
import '../../../../core/utils/translator.dart';
import '../../validation/forms/home_id.dart';

part 'join_home_state.dart';

class JoinHomeCubit extends Cubit<JoinHomeState> {
  final HomeRepository homeRepository;
  final HomesCubit homesCubit;
  JoinHomeCubit(
    this.homeRepository, {
    required this.homesCubit,
  }) : super(const JoinHomeState());

  void onHomeIdChanged(String newId) {
    final homeId = HomeId.dirty(newId);
    emit(
      state.copyWith(
        homeId: homeId,
        status: JoinHomeStatus.idle,
        error: null,
      ),
    );
  }

  Future<void> joinHome(String userId, Translator translator) async {
    emit(state.copyWith(status: JoinHomeStatus.loading));
    if (state.validationFailure != null) {
      emit(state.copyWith(
        homeId: HomeId.dirty(state.homeId.value),
        error: AppFailure.fromValidationFailure(
            state.validationFailure!, translator),
        status: JoinHomeStatus.error,
      ));
      return;
    }

    final response = await homeRepository
        .joinHome(JoinHomeParams(userId: userId, homeId: state.homeId.value));

    return response.fold((l) {
      emit(state.copyWith(
          homeId: HomeId.dirty(state.homeId.value),
          error: AppFailure.fromTaskFailure(l, translator),
          status: JoinHomeStatus.error));
    }, (r) {
      homesCubit.addHome(homeEntity: r.joinedHome);
      emit(state.copyWith(status: JoinHomeStatus.joined, error: null));
    });
  }
}
