import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/common.dart';

class CustomTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function()? onDone;
  final Function()? onPasteClick;

  final TextEditingController? controller;

  final int? maxLine;

  final int? maxCharacter;

  final bool showSign;

  final Widget? prefixIcon;

  final bool enable;
  final EdgeInsets? scrollPadding;
  final FocusNode? focusNode;
  final bool maxLengthEnforced;

  /// 是否展示为盒子样式
  final bool boxField;

  // 最大高度
  // 这个属性在 maxLine = null时生效, 输入框自适应文本高度,当达到这个高度后,高度不在增加.
  final double? maxHeight;

  // 边框宽度 默认.5
  final double enableBorderWidth;
  final double focusedBorderWidth;

  final bool needRequired;

  final int hintMaxLines;
  final double counterSize;
  final double bottomPadding;

  final String? hintText;

  final TextStyle? inputTextStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? counterStyle;

  final TextAlign textAlign;

  final bool isDense;

  // 自定义counter
  final Widget? Function(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCustomCounter;

  final EdgeInsetsGeometry? contentPadding;

  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.onChanged,
    this.needRequired = false,
    this.controller,
    this.prefixIcon,
    this.onDone,
    this.hintText,
    this.maxLine,
    this.maxCharacter,
    this.showSign = false,
    this.enable = true,
    this.scrollPadding,
    this.onPasteClick,
    this.focusNode,
    this.maxHeight,
    this.maxLengthEnforced = true,
    this.boxField = false,
    this.enableBorderWidth = .5,
    this.focusedBorderWidth = 1.5,
    this.hintMaxLines = 20,
    this.counterSize = 12,
    this.bottomPadding = 0,
    this.inputTextStyle,
    this.hintTextStyle,
    this.counterStyle,
    this.textAlign = TextAlign.left,
    this.isDense = true,
    this.buildCustomCounter,
    this.keyboardType,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    BoxConstraints? constraints;
    TextStyle inputTs = inputTextStyle ?? Styles.textNormal(14);
    TextStyle hintTs = hintTextStyle ?? Styles.textNormal(14);

    if (maxHeight != null) {
      constraints = BoxConstraints(
        minHeight: 40,
        maxHeight: maxHeight! + 30, // 加上30，包括了底部下划线和计数的高度
        minWidth: SizeConfig.screenWidth,
        maxWidth: SizeConfig.screenWidth,
      );
    }

    if (boxField) {
      return Column(
        children: [
          if (prefixIcon != null)
            Column(
              children: [
                prefixIcon!,
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          Container(
            constraints: constraints,
            child: TextField(
              buildCounter: buildCustomCounter,
              textAlign: textAlign,
              scrollPhysics: const BouncingScrollPhysics(),
              controller: controller,
              maxLength: maxCharacter,
              maxLines: maxLine,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: maxLengthEnforced
                  ? MaxLengthEnforcement.enforced
                  : MaxLengthEnforcement.none,
              onChanged: (str) {
                onChanged?.call(str);
              },
              onEditingComplete: () {
                onDone?.call();
              },
              enabled: enable,
              focusNode: focusNode,
              keyboardAppearance: Brightness.light,
              textInputAction: TextInputAction.newline,

              ///不显示输入时正在编辑单词的下划线（修改decorationColor还是有）
              style: inputTs.copyWith(
                decorationThickness: 0,
              ),
              cursorWidth: 3,
              cursorColor: Styles.normalBlue,
              decoration: InputDecoration(
                contentPadding: contentPadding,
                filled: true,
                fillColor: Styles.greyBgColor,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 0.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    color: Styles.transparent,
                    width: 1,
                  ),
                ),
                hintText: hintText,
                counterStyle: counterStyle ?? Styles.textLight(counterSize),
                hintMaxLines: 20,
                //使初始高度能看到hint，尽量给的大值
                hintStyle: hintTs,
              ),
              scrollPadding:
                  scrollPadding ?? EdgeInsets.all(20.0 * (maxLine ?? 0) + 15),
            ),
          )
        ],
      );
    }

    return Container(
      constraints: constraints,
      child: TextField(
        buildCounter: buildCustomCounter,
        textAlign: textAlign,
        scrollPhysics: const BouncingScrollPhysics(),
        controller: controller,
        maxLength: maxCharacter,
        maxLines: maxLine,
        maxLengthEnforcement: maxLengthEnforced
            ? MaxLengthEnforcement.enforced
            : MaxLengthEnforcement.none,
        onChanged: (str) {
          onChanged?.call(str);
        },
        enabled: enable,
        focusNode: focusNode,
        keyboardAppearance: Brightness.light,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,

        /// 不显示输入时正在编辑单词的下划线（修改decorationColor还是有）
        style: inputTs.copyWith(
          decorationThickness: 0,
        ),
        cursorColor: Styles.normalBlue,
        cursorWidth: 3,
        decoration: InputDecoration(
          isDense: isDense,
          contentPadding: EdgeInsets.only(bottom: bottomPadding),
          prefixIcon: prefixIcon,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 27),
          hintText: hintText,
          counterStyle: counterStyle ?? Styles.textLight(counterSize),
          hintMaxLines: hintMaxLines,
          //使初始高度能看到hint，尽量给的大值
          hintStyle: hintTs,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Styles.greyBgColor, width: focusedBorderWidth),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Styles.greyBgColor, width: enableBorderWidth)),
        ),
        scrollPadding:
            scrollPadding ?? EdgeInsets.all(20.0 * (maxLine ?? 0) + 15),
        keyboardType: keyboardType,
      ),
    );
  }
}
