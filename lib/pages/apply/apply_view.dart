import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/pages/add/add_state.dart';
import 'package:relax_chat/widgets/base/base_app_bar.dart';
import 'package:relax_chat/widgets/custom_text_field.dart';
import 'package:relax_chat/widgets/image/round_avatar.dart';

import '../../common/common.dart';
import 'apply_logic.dart';

class ApplyPage extends StatelessWidget {
  ApplyPage({super.key});

  final logic = Get.put(ApplyLogic());
  final state = Get.find<ApplyLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logic.onTapBg,
      child: Scaffold(
        backgroundColor: Styles.white,
        body: Column(
          children: [
            BaseAppBar(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.applyType == FindType.person ? '申请好友' : '申请加群',
                        style: Styles.textFiraNormal(18.w),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  16.w,
                  16.w,
                  SizeConfig.bottomMargin,
                ),
                child: Column(
                  children: [
                    if (state.groupRoom != null)
                      infoCell(state.groupRoom!.name, state.groupRoom!.avatar),
                    if (state.user != null)
                      infoCell(state.user!.name, state.user!.avatar),
                    SizedBox(
                      height: 20.w,
                    ),
                    CustomTextField(
                      boxField: true,
                      controller: state.txtController,
                      focusNode: state.focusNode,
                      onChanged: (val) {
                        state.inputStr.value = val;
                      },
                      prefixIcon: Row(
                        children: [
                          Text(
                            '填写申请信息',
                            style: Styles.textFiraNormal(16.w)
                                .copyWith(color: Styles.greyText),
                          ),
                        ],
                      ),
                      maxCharacter: 200,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: logic.apply,
                      child: Container(
                        width: 248.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Styles.deepBlue,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Text(
                          '发送申请',
                          style: Styles.textFiraNormal(16.w)
                              .copyWith(color: Styles.whiteText),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCell(String name, String avatarUrl) {
    return Row(
      children: [
        RoundAvatar(height: 48.w, url: avatarUrl),
        SizedBox(
          width: 8.w,
        ),
        Text(
          name,
          style: Styles.textFiraNormal(24.w),
        ),
      ],
    );
  }
}
