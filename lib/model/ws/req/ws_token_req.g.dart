// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_token_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSTokenReq _$WSTokenReqFromJson(Map<String, dynamic> json) => WSTokenReq(
      (json['type'] as num).toInt(),
      defaultTokenData(json['req']),
    );

Map<String, dynamic> _$WSTokenReqToJson(WSTokenReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'req': instance.req,
    };

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
      json['token'] as String? ?? '',
    );

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
      'token': instance.token,
    };
