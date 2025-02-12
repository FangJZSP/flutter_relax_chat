import 'package:json_annotation/json_annotation.dart';
import '../ws/resp/ws_msg_model.dart';

part 'message_cell_model.g.dart';

enum MessageCellType { addNew, addOld, update, chatMarker, composing, insert }

@JsonSerializable()
class MessageCellModel {
  @JsonKey(fromJson: defaultWSMessageModel)
  WSMessageModel messageModel;

  int? chatMarker;

  @JsonKey(defaultValue: MessageCellType.addNew)
  MessageCellType msgCellType;

  @JsonKey(defaultValue: false)
  bool cachedMsg;

  int? insertIndex;

  MessageCellModel({
    required this.messageModel,
    required this.msgCellType,
    this.cachedMsg = false,
    this.chatMarker,
    this.insertIndex,
  });

  factory MessageCellModel.fromJson(Map<String, dynamic> json) =>
      _$MessageCellModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageCellModelToJson(this);

  void updateMessage(WSMessageModel message) {
    messageModel = message;
  }
}
