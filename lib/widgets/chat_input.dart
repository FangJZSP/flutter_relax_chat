import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/common/size_config.dart';

import '../common/common.dart';

enum InputBarState { normal, keyboardShow, pendingSend }

class ChatInput extends StatefulWidget {
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final Function()? onClickInput;
  final Function(String)? sendCallback;
  final Function()? onTypingCallback;
  final String? placeHolder;
  final TextStyle? hintStyle;
  final Color? bgColor;

  const ChatInput({
    this.focusNode,
    this.editingController,
    this.hintStyle,
    this.bgColor,
    this.placeHolder,
    this.onClickInput,
    this.sendCallback,
    this.onTypingCallback,
    super.key,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  RxString inputText = ''.obs;

  Rx<InputBarState> inputState = InputBarState.normal.obs;

  RxBool get keyboardShow =>
      (inputState.value == InputBarState.keyboardShow).obs;

  @override
  void initState() {
    super.initState();
    widget.editingController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus ?? false) {
        inputState.value = InputBarState.keyboardShow;
      } else {
        inputState.value = InputBarState.normal;
      }
    });
  }

  void _onTapInputFiled() {
    inputState.value = inputState.value = InputBarState.keyboardShow;
    widget.onClickInput?.call();
  }

  void _onClickRightButton() {
    _onSendMsg(widget.editingController?.text ?? '');
    widget.focusNode?.requestFocus();
  }

  void _onSendMsg(String text) async {
    if (text.isEmpty) {
      return;
    }
    widget.sendCallback?.call(text);
    widget.editingController?.clear();
    if (widget.focusNode?.hasFocus ?? false) {
      if (widget.editingController?.text.isEmpty ?? false) {
        inputState.value = InputBarState.keyboardShow;
      }
    } else {
      inputState.value = InputBarState.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.w,
      decoration: BoxDecoration(
        color: widget.bgColor ?? Styles.white,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leftButton(),
          SizedBox(
            width: 6.w,
          ),
          Expanded(
            child: TextField(
              onTap: _onTapInputFiled,
              scrollPhysics: const BouncingScrollPhysics(),
              controller: widget.editingController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (String text) {
                inputText.value = text;
                widget.onTypingCallback?.call();
              },
              focusNode: widget.focusNode,
              enabled: true,
              keyboardAppearance: Brightness.light,
              textInputAction: TextInputAction.newline,
              style: null,
              cursorColor: Styles.normalBlue,
              cursorWidth: 3.w,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: widget.placeHolder ?? Strings.hintText,
                isCollapsed: true,
                contentPadding: EdgeInsets.all(8.w),
                hintStyle: widget.hintStyle ??
                    Styles.textNormal(16).copyWith(color: Styles.greyText),
                filled: true,
                fillColor: Styles.white,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 0.5,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 0.5,
                  ),
                ),
                //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 12),
              ),
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
          rightButton(),
        ],
      ),
    );
  }

  Widget leftButton() {
    return Icon(
      Icons.mic_none_outlined,
      size: 24.w,
    );
  }

  Widget rightButton() {
    return Obx(() {
      return inputText.isEmpty
          ? Row(
              children: [
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: 24.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Icon(
                  Icons.add_circle_outline,
                  size: 24.w,
                ),
              ],
            )
          : Row(
              children: [
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: 24.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                GestureDetector(
                  onTap: _onClickRightButton,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
                    decoration: BoxDecoration(
                      color: Styles.normalBlue,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text(
                      '发送',
                      style: Styles.textNormal(12.w).copyWith(
                        color: Styles.whiteText,
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }
}
