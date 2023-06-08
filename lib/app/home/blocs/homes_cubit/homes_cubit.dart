import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../../../core/failures/app_failure.dart';

part 'homes_state.dart';

class HomesCubit extends Cubit<HomesState> {
  final HomeRepository homeRepository;
  HomesCubit(this.homeRepository) : super(const HomesState(homes: []));
  Future<void> deleteHome(BuildContext context,
      {required String homeId}) async {
    final response =
        await homeRepository.deleteHome(DeleteHomeParams(homeId: homeId));
    response.fold((l) {
      emit(state.copyWith(
        failure: AppFailure.fromTaskFailure(l, context.translator),
        status: HomesStatus.error,
      ));
    }, (r) {
      final newHomes = state.homes.toList();
      newHomes.removeWhere(
        (element) => element.id == homeId,
      );

      emit(state.copyWith(
        failure: null,
        homes: newHomes,
        status: HomesStatus.retrieved,
      ));
    });
  }

  Future<void> joinHome(
      String homeId, String userId, BuildContext context) async {
    final response = await homeRepository
        .joinHome((JoinHomeParams(homeId: homeId, userId: userId)));

    response.fold((l) {
      emit(state.copyWith(
        failure: AppFailure.fromTaskFailure(l, context.translator),
        status: HomesStatus.error,
      ));
    }, (r) {
      final newHomes = state.homes.toList();
      newHomes.add(r.joinedHome);

      emit(state.copyWith(
        homes: newHomes,
        status: HomesStatus.retrieved,
      ));
    });
  }

  Future<void> getHomesOfUser(String userId, BuildContext context) async {
    final response =
        await homeRepository.getHomes(GetHomesParams(userId: userId));

    response.fold((l) {
      emit(state.copyWith(
        failure: AppFailure.fromTaskFailure(l, context.translator),
        status: HomesStatus.error,
      ));
    }, (r) {
      emit(state.copyWith(
        homes: r.homes,
        failure: null,
        status: HomesStatus.retrieved,
      ));
    });
  }

  

  void addHome({required HomeEntity homeEntity}) {
    final homes = state.homes.toList();
    homes.add(homeEntity);
    emit(state.copyWith(
      homes: homes,
      failure: null,
      status: HomesStatus.retrieved,
    ));
  }
}
