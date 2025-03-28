// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_apply_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendApplyListResp _$FriendApplyListRespFromJson(Map<String, dynamic> json) =>
    FriendApplyListResp(
      (json['list'] as List<dynamic>?)
              ?.map((e) => FriendModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      (json['size'] as num?)?.toInt() ?? 20,
      (json['page'] as num?)?.toInt() ?? 1,
      (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FriendApplyListRespToJson(
        FriendApplyListResp instance) =>
    <String, dynamic>{
      'list': instance.list,
      'size': instance.size,
      'page': instance.page,
      'total': instance.total,
    };
