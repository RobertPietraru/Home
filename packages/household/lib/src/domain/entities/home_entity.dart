import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  final String id;
  final String name;
  final List<String> people;
  final List<String> admins;

  const HomeEntity({
    required this.id,
    required this.name,
    required this.people,
    required this.admins,
  });

  @override
  List<Object?> get props => [id, name, people, admins];

  HomeEntity copyWith({
    String? id,
    String? name,
    List<String>? people,
    List<String>? admins,
  }) {
    return HomeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      people: people ?? this.people,
      admins: admins ?? this.admins,
    );
  }

  static const mock =
      HomeEntity(id: "MOCK", name: "MOCK", people: [], admins: []);
}
