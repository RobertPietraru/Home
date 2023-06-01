import 'package:equatable/equatable.dart';

import '../../../domain/entities/session/player_entity.dart';

class PlayerDto extends Equatable {
  final String userId;
  final String name;
  final double score;
  final int correctAnswers;

  static const String userIdField = 'userId';
  static const String scoreField = 'score';
  static const String nameField = 'name';
  static const String correctAnswersField = 'correctAnswers';

  const PlayerDto({
    required this.userId,
    required this.name,
    required this.score,
    required this.correctAnswers,
  });

  @override
  List<Object?> get props => [userId, name];

  PlayerDto copyWith(
      {String? userId, String? name, double? score, int? correctAnswers}) {
    return PlayerDto(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        score: score ?? this.score,
        correctAnswers: correctAnswers ?? this.correctAnswers);
  }

  factory PlayerDto.fromEntity(PlayerEntity player) {
    return PlayerDto(
        correctAnswers: player.correctAnswers,
        userId: player.userId,
        name: player.name,
        score: player.score);
  }
  PlayerEntity toEntity(PlayerDto player) {
    return PlayerEntity(
        correctAnswers: correctAnswers,
        userId: player.userId,
        name: player.name,
        score: player.score);
  }

  Map<dynamic, dynamic> toMap() {
    return {
      userIdField: userId,
      nameField: name,
      scoreField: score,
      correctAnswersField: correctAnswers,
    };
  }

  factory PlayerDto.fromMap(Map<dynamic, dynamic> map) {
    return PlayerDto(
        correctAnswers: (map[correctAnswersField] as num).toInt(),
        userId: map[userIdField],
        name: map[nameField],
        score: (map[scoreField] as int).toDouble());
  }
}
