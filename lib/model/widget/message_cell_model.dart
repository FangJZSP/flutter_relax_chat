import 'package:json_annotation/json_annotation.dart';
import '../ws/resp/ws_msg_model.dart';

part 'message_cell_model.g.dart';

enum MessageCellType {
  addNew,
  addOld,
  update,
  chatMarker,
  composing,
  insert,
}

enum MessageStatus {
  none(0),
  delivering(1),
  succeed(2),
  failed(3),
  ;

  final int code;

  const MessageStatus(this.code);

  static MessageStatus? fromCode(int code) {
    for (var e in MessageStatus.values) {
      if (code == e.code) {
        return e;
      }
    }
    return null;
  }
}

@JsonSerializable()
class MessageCellModel {
  @JsonKey(fromJson: defaultWSMessageModel)
  WSMessageModel messageModel;

  @JsonKey(defaultValue: MessageCellType.addNew)
  MessageCellType msgCellType;

  /// 发送消息标识消息id 用于更新
  @JsonKey(defaultValue: '')
  String messageId;

  /// UI展示消息列表中不存在的消息
  @JsonKey(defaultValue: false)
  bool cachedMsg;

  /// 发送消息时消息的状态
  @JsonKey(defaultValue: 0)
  int status;

  int? chatMarker;

  int? insertIndex;

  MessageCellModel(
    this.messageModel,
    this.msgCellType,
    this.messageId,
    this.cachedMsg,
    this.status,
    this.chatMarker,
    this.insertIndex,
  );

  factory MessageCellModel.fromJson(Map<String, dynamic> json) =>
      _$MessageCellModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageCellModelToJson(this);

  void updateMessage(WSMessageModel message) {
    messageModel = message;
  }
}
