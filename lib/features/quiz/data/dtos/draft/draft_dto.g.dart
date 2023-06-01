// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftDtoAdapter extends TypeAdapter<DraftDto> {
  @override
  final int typeId = 5;

  @override
  DraftDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraftDto(
      lesson: fields[6] as String?,
      questions: (fields[5] as List).cast<QuestionDto>(),
      title: fields[1] as String?,
      isPublic: fields[2] as bool,
      creatorId: fields[3] as String,
      imageUrl: fields[4] as String?,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DraftDto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isPublic)
      ..writeByte(3)
      ..write(obj.creatorId)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.questions)
      ..writeByte(6)
      ..write(obj.lesson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
