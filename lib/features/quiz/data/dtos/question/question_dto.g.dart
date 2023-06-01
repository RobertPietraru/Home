// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionDtoAdapter extends TypeAdapter<QuestionDto> {
  @override
  final int typeId = 2;

  @override
  QuestionDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionDto(
      id: fields[7] as String,
      text: fields[6] as String?,
      image: fields[3] as String?,
      options: (fields[4] as List?)?.cast<MultipleChoiceOptionDto>(),
      quizId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionDto obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.quizId)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.options)
      ..writeByte(6)
      ..write(obj.text)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultipleChoiceOptionDtoAdapter
    extends TypeAdapter<MultipleChoiceOptionDto> {
  @override
  final int typeId = 3;

  @override
  MultipleChoiceOptionDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoiceOptionDto(
      text: fields[0] as String?,
      isCorrect: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoiceOptionDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.isCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceOptionDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
