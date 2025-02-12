import 'package:json_annotation/json_annotation.dart';

part 'cache_file_model.g.dart';

@JsonSerializable()
class CacheFileModel {
  @JsonKey(defaultValue: '')
  String url;

  @JsonKey(defaultValue: '')
  String path;

  @JsonKey(defaultValue: 0)
  int saveTime;

  @JsonKey(defaultValue: '')
  String type;

  CacheFileModel({
    required this.url,
    required this.path,
    required this.saveTime,
    required this.type,
  });

  factory CacheFileModel.fromJson(Map<String, dynamic> json) =>
      _$CacheFileModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CacheFileModelToJson(this).cast<String, dynamic>();
}
