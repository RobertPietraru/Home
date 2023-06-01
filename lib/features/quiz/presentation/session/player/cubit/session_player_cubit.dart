import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/globals.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/domain/failures/quiz_failures.dart';
import 'package:testador/features/quiz/domain/usecases/quiz_usecases.dart';

import '../../../../domain/entities/question_entity.dart';

part 'session_player_state.dart';

class SessionPlayerCubit extends Cubit<SessionPlayerState> {
  final JoinSessionUsecase joinSessionUsecase;
  final SubscribeToSessionUsecase subscribeToSessionUsecase;
  final GetQuizByIdUsecase getQuizByIdUsecase;
  final SendAnswerUsecase sendAnswerUsecase;
  final String userId;
  StreamSubscription<SessionEntity>? _sessionsStreamSubscription;

  SessionPlayerCubit(this.joinSessionUsecase, this.subscribeToSessionUsecase,
      this.getQuizByIdUsecase, this.sendAnswerUsecase, {required this.userId})
      : super(SessionPlayerCodeRetrival(
            failure: null, userId: userId, sessionId: '', isLoading: false));

  Future<void> subscribeToSession() async {
    if (this.state is! SessionPlayerCodeRetrival) return;
    final state = this.state as SessionPlayerCodeRetrival;
    final response = await subscribeToSessionUsecase
        .call(SubscribeToSessionUsecaseParams(sessionId: state.sessionId));
    response.fold((l) {
      emit(SessionPlayerCodeRetrival(
        failure: l,
        isLoading: false,
        sessionId: state.sessionId.replaceAll(' ', ''),
        userId: state.userId,
      ));
    }, (r) {
      _sessionsStreamSubscription = r.sessions.listen(sessionStreamHandler);
      emit(SessionPlayerNameRetrival(
        name: '',
        userId: userId,
        session: r.currentSession,
        isLoading: state.isLoading,
      ));
    });
  }

  void sessionStreamHandler(SessionEntity session) {
    if (state is SessionPlayerInGame) {
      final state = this.state as SessionPlayerInGame;
      if (state.session.status != session.status) {
        // they moved to a different screen
        emit(state.copyWith(isSent: false, session: session));
        return;
      }
    }
    emit(state.withSession(session));
  }

  Future<void> joinSession() async {
    if (this.state is! SessionPlayerNameRetrival) return;
    final state = this.state as SessionPlayerNameRetrival;
    final response = await joinSessionUsecase.call(JoinSessionUsecaseParams(
      userId: userId,
      name: state.name,
      sessionId: state.session.id,
    ));

    response.fold((l) {
      emit(SessionPlayerNameRetrival(
        session: state.session,
        name: state.name,
        userId: state.userId,
        failure: l,
        isLoading: state.isLoading,
      ));
    }, (sessionResponse) async {
      final response = await getQuizByIdUsecase
          .call(GetQuizByIdUsecaseParams(quizId: state.session.quizId));
      response.fold(
        (l) {
          emit(SessionPlayerNameRetrival(
            session: state.session,
            name: state.name,
            userId: state.userId,
            failure: l,
            isLoading: state.isLoading,
          ));
        },
        (quizResponse) {
          emit(SessionPlayerInGame(
            name: state.name,
            quiz: quizResponse.quiz,
            failure: null,
            session: sessionResponse.session,
            userId: state.userId,
          ));
        },
      );
    });
  }

  void updateCode(String e) {
    if (this.state is! SessionPlayerCodeRetrival) return;
    final state = this.state as SessionPlayerCodeRetrival;
    emit(SessionPlayerCodeRetrival(
      failure: null,
      userId: state.userId,
      sessionId: e,
      isLoading: state.isLoading,
    ));
  }

  @override
  Future<void> close() {
    _sessionsStreamSubscription?.cancel();
    return super.close();
  }

  void updateName(String e) {
    if (this.state is! SessionPlayerNameRetrival) return;
    final state = this.state as SessionPlayerNameRetrival;
    emit(SessionPlayerNameRetrival(
      name: e,
      session: state.session,
      failure: null,
      userId: state.userId,
      isLoading: state.isLoading,
    ));
  }
}
