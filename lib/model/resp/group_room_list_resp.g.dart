// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_room_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupRoomListResp _$GroupRoomListRespFromJson(Map<String, dynamic> json) =>
    GroupRoomListResp(
      (json['list'] as List<dynamic>?)
              ?.map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GroupRoomListRespToJson(GroupRoomListResp instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
