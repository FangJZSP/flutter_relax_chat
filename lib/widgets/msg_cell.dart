import 'package:flutter/material.dart';
import 'package:relax_chat/model/msg_model.dart';
import 'package:relax_chat/model/widget/message_cell_model.dart';

import '../common/common.dart';
import 'image/round_avatar.dart';

class MsgCell extends StatefulWidget {
  final MessageCellModel cell;

  const MsgCell({
    required this.cell,
    super.key,
  });

  @override
  State<MsgCell> createState() => _MsgCellState();
}

class _MsgCellState extends State<MsgCell> {
  late MessageCellModel _cell;

  @override
  void initState() {
    super.initState();
    _cell = widget.cell;
  }

  @override
  Widget build(BuildContext context) {
    return _msgCell();
  }

  @override
  void didUpdateWidget(covariant MsgCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cell = widget.cell;
  }

  Widget _msgCell() {
    switch (MessageModelType.fromCode(_cell.messageModel.msg.msgType)) {
      case MessageModelType.text:
        return _cell.messageModel.senderIsMe ? sendMsgCell() : receiveMsgCell();
      case MessageModelType.system:
        return systemMsgCell();
      case null:
      default:
        return Text(
          '消息气泡暂未处理这种类型',
          style: Styles.textNormal(10).copyWith(color: Styles.greyText),
        );
    }
  }

  Widget msgStatus() {
    if (_cell.status == MessageStatus.delivering.code) {
      return SizedBox(
        width: 12.w,
        height: 12.w,
        child: CircularProgressIndicator(
          strokeWidth: 1.w,
        ),
      );
    }
    // if (_model.status == MessageStatus.succeed.code) {
    //   return Icon(
    //     Icons.check_circle_outline,
    //     size: 14.w,
    //     color: Styles.grey,
    //   );
    // }
    if (_cell.status == MessageStatus.failed.code) {
      return Icon(
        Icons.error_outline,
        size: 14.w,
        color: Styles.red,
      );
    }
    return Container();
  }

  Widget sendMsgCell() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _cell.messageModel.msg.senderName,
                style: Styles.textNormal(12.w).copyWith(color: Styles.greyText),
              ),
              SizedBox(height: 4.w),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 264.w,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Styles.sendBubbleColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_cell.messageModel.msg.reply.id > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '| ${_cell.messageModel.msg.reply.username}: ${_cell.messageModel.msg.reply.body}',
                              style: Styles.textNormal(14)
                                  .copyWith(color: Styles.grey),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        Text(
                          _cell.messageModel.msg.body.content,
                          style: Styles.textNormal(14)
                              .copyWith(color: Styles.blackText),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    left: -18,
                    child: msgStatus(),
                  )
                ],
              ),
            ],
          ),
          SizedBox(width: 8.w),
          RoundAvatar(
            height: 35.w,
            url: _cell.messageModel.msg.senderAvatar,
            borderDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Styles.grey.withOpacity(.1),
                )),
          ),
        ],
      ),
    );
  }

  Widget receiveMsgCell() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundAvatar(
            height: 35.w,
            url: _cell.messageModel.msg.senderAvatar,
            borderDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Styles.grey.withOpacity(.1),
                )),
          ),
          SizedBox(
            width: 8.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _cell.messageModel.msg.senderName,
                style: Styles.textNormal(12.w).copyWith(color: Styles.greyText),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 264.w,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Styles.receiveBubbleColor,
                ),
                padding: EdgeInsets.all(10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cell.messageModel.msg.reply.id > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '| ${_cell.messageModel.msg.reply.username}: ${_cell.messageModel.msg.reply.body}',
                          style: Styles.textNormal(14.w)
                              .copyWith(color: Styles.grey),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    Text(
                      _cell.messageModel.msg.body.content,
                      style: Styles.textNormal(14.w)
                          .copyWith(color: Styles.blackText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget systemMsgCell() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: const BoxDecoration(
            color: Styles.transparent,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Text(
          _cell.messageModel.msg.body.toString(),
          style: Styles.textNormal(12).copyWith(color: Styles.greyText),
        ));
  }
}
