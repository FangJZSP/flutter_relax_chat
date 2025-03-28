// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListResp _$UserListRespFromJson(Map<String, dynamic> json) => UserListResp(
      (json['list'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserListRespToJson(UserListResp instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
