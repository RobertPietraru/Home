import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:testador/features/quiz/domain/usecases/session/show_leaderboard.dart';

part 'session_admin_state.dart';

class SessionAdminCubit extends Cubit<SessionAdminState> {
  final SubscribeToSessionUsecase subscribeToSessionUsecase;
  final CreateSessionUsecase createSessionUsecase;
  final JoinSessionUsecase joinSessionUsecase;
  final DeleteSessionUsecase deleteSessionUsecase;
  final ShowQuestionResultsUsecase showQuestionResultsUsecase;
  final ShowLeaderboardUsecase showLeaderboardUsecase;
  final GoToNextQuestionUsecase goToNextQuestionUsecase;

  final BeginSessionUsecase beginSessionUsecase;

  late final StreamSubscription<SessionEntity> _sessionsStreamSubscription;

  SessionAdminCubit(
    this.subscribeToSessionUsecase,
    this.createSessionUsecase,
    this.joinSessionUsecase,
    this.deleteSessionUsecase,
    this.beginSessionUsecase,
    this.showQuestionResultsUsecase,
    this.showLeaderboardUsecase,
    this.goToNextQuestionUsecase, {
    required QuizEntity quiz,
  }) : super(SessionAdminLoadingState(quiz: quiz)) {
    createAndSubscribe();
  }

  Future<void> createAndSubscribe() async {
    final responseCreation = await createSessionUsecase.call(
        CreateSessionUsecaseParams(
            creatorId: state.quiz.creatorId, quiz: state.quiz));
    responseCreation.fold(
      (l) {
        emit(SessionAdminFailureState(quiz: state.quiz, failure: l));
        return;
      },
      (r) async {
        emit(SessionAdminMatchState(quiz: state.quiz, session: r.session));

        final responseSubscription = await subscribeToSessionUsecase
            .call(SubscribeToSessionUsecaseParams(sessionId: r.session.id));
        responseSubscription.fold(
          (failure) => emit(
              SessionAdminFailureState(quiz: state.quiz, failure: failure)),
          (r) => _sessionsStreamSubscription = r.sessions.listen(
            (entity) {
              emit(SessionAdminMatchState(quiz: state.quiz, session: entity));
            },
          ),
        );
      },
    );
  }

  Future<void> beginSession() async {
    if (this.state is! SessionAdminMatchState) return;
    final state = this.state as SessionAdminMatchState;

    final response = await beginSessionUsecase
        .call(BeginSessionUsecaseParams(session: state.session));
    response.fold(
      (l) => emit(SessionAdminMatchState(
          quiz: state.quiz, session: state.session, failure: l)),
      (r) => emit(SessionAdminMatchState(
          quiz: state.quiz, session: r.session, failure: null)),
    );
  }

  Future<void> deleteAndUnsubscribe() async {
    if (this.state is SessionAdminLoadingState) return;
    final state = this.state as SessionAdminMatchState;
    final response = await deleteSessionUsecase
        .call(DeleteSessionUsecaseParams(session: state.session));
    // response.fold(
    //   (l) => emit(SessionInGameState(
    //       session: state.session, quiz: state.quiz, failure: l)),
    //   (r) => emit(SessionDeletedState(quiz: state.quiz)),
    // );

    _sessionsStreamSubscription.cancel();
  }

  Future<void> showQuestionResults() async {
    if (this.state is! SessionAdminMatchState) return;
    final state = this.state as SessionAdminMatchState;

    final response = await showQuestionResultsUsecase.call(
        ShowQuestionResultsUsecaseParams(
            session: state.session, quiz: state.quiz));

    response.fold((l) {
      emit(state.copyWith(failure: l));
    }, (r) {
      emit(state.copyWith(session: r.session));
    });
  }

  Future<void> showLeaderboard() async {
    if (this.state is! SessionAdminMatchState) return;
    final state = this.state as SessionAdminMatchState;

    final response = await showLeaderboardUsecase
        .call(ShowLeaderboardUsecaseParams(session: state.session));

    response.fold((l) {
      emit(state.copyWith(failure: l));
    }, (r) {
      emit(state.copyWith(session: r.session));
    });
  }

  Future<void> goToNextQuestion() async {
    if (this.state is! SessionAdminMatchState) return;
    final state = this.state as SessionAdminMatchState;

    final response = await goToNextQuestionUsecase.call(
        GoToNextQuestionUsecaseParams(
            session: state.session, quiz: state.quiz));

    response.fold((l) {
      emit(state.copyWith(failure: l));
    }, (r) {
      emit(state.copyWith(session: r.session));
    });
  }

  @override
  Future<void> close() {
    _sessionsStreamSubscription.cancel();
    return super.close();
  }
}
