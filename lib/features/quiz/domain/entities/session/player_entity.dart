import 'package:equatable/equatable.dart';

class PlayerEntity extends Equatable {
  final String userId;
  final String name;
  final double score;
  final int correctAnswers;

  const PlayerEntity({
    required this.correctAnswers,
    required this.userId,
    required this.name,
    required this.score,
  });

  @override
  List<Object?> get props => [userId, name, score];

  PlayerEntity copyWith(
      {String? userId, String? name, double? score, int? correctAnswers}) {
    return PlayerEntity(
      correctAnswers: correctAnswers ?? this.correctAnswers,
      score: score ?? this.score,
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }
}
