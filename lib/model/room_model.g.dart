// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      (json['roomId'] as num?)?.toInt() ?? 0,
      (json['type'] as num?)?.toInt() ?? 1,
      json['name'] as String? ?? '',
      json['avatar'] as String? ?? '',
      (json['role'] as num?)?.toInt() ?? 3,
      (json['createTime'] as num?)?.toInt() ?? 0,
      json['isJoined'] as bool? ?? true,
      (json['memberCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'type': instance.type,
      'name': instance.name,
      'avatar': instance.avatar,
      'role': instance.role,
      'createTime': instance.createTime,
      'isJoined': instance.isJoined,
      'memberCount': instance.memberCount,
    };
