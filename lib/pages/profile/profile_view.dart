import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/widgets/image/network_image_widget.dart';

import '../../common/size_config.dart';
import '../../common/styles.dart';
import '../../manager/user_manager.dart';
import '../../widgets/image/round_avatar.dart';
import 'profile_logic.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final logic = Get.put(ProfileLogic());
  final state = Get.find<ProfileLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.white,
      child: Stack(
        children: [
          CustomScrollView(
            controller: state.scrollController,
            physics: state.scrollPhysics,
            slivers: [
              SliverAppBar(
                clipBehavior: Clip.none,
                titleSpacing: 0,
                title: Obx(() {
                  return Text(
                    '用户信息',
                    style: Styles.textBold(16.w).copyWith(
                        color: Styles.blackText
                            .withOpacity(state.scrollColorOpacity.value)),
                  );
                }),
                leading: Obx(() {
                  return IconButton(
                    onPressed: logic.back,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: state.scrollColorOpacity.value > 0.3
                          ? Styles.black
                              .withOpacity(state.scrollColorOpacity.value)
                          : Styles.white,
                      size: 16.w,
                    ),
                  );
                }),
                stretch: true,
                pinned: true,
                expandedHeight: state.expandedHeight,
                backgroundColor: Styles.white,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // 计算折叠比例，用于动态调整UI
                    double collapsePct =
                        (constraints.maxHeight - kToolbarHeight) /
                            (state.expandedHeight - kToolbarHeight);
                    collapsePct = collapsePct.clamp(0.0, 1.0);

                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      stretchModes: const [
                        StretchMode.zoomBackground,
                      ],
                      background: Stack(
                        children: [
                          // 背景图片
                          Positioned.fill(
                            child: MyNetworkImage(
                              imgUrl: state.user.value.avatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.w,
                            left: SizeConfig.bodyPadding,
                            right: SizeConfig.bodyPadding,
                            child: Opacity(
                              opacity: collapsePct,
                              child: Text(
                                'Relax',
                                style: Styles.textBold(24.w)
                                    .copyWith(color: Styles.whiteText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Divider(
                      color: Styles.grey.withOpacity(0.1),
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        SizeConfig.bodyPadding,
                        SizeConfig.bodyPadding,
                        SizeConfig.bodyPadding,
                        0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RoundAvatar(
                                height: state.avatarHeight,
                                url: state.user.value.avatar,
                                borderDecoration: BoxDecoration(
                                  border: Border.all(color: Styles.white),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.value.name,
                                    style: Styles.textBold(18.w)
                                        .copyWith(color: Styles.blackText),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'uid: ${state.user.value.uid}',
                                    style: Styles.textNormal(12.w)
                                        .copyWith(color: Styles.greyText),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 8.w),
                          Row(
                            children: [
                              Icon(
                                state.user.value.sex == 1
                                    ? Icons.male
                                    : Icons.female,
                                color: Styles.lightBlue,
                                size: 14.w,
                              ),
                              Text(
                                state.user.value.sex == 1 ? '男' : '女',
                                style: Styles.textNormal(10.w)
                                    .copyWith(color: Styles.greyText),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Styles.grey,
                                size: 8.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
