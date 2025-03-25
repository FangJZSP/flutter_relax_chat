import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_chat/widgets/image/network_image_widget.dart';

import '../../common/size_config.dart';
import '../../common/styles.dart';
import '../../manager/user_manager.dart';
import '../../widgets/image/round_avatar.dart';
import 'profile_logic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                title: null,
                leading: null,
                centerTitle: true,
                stretch: true,
                pinned: true,
                expandedHeight: state.expandedHeight,
                backgroundColor: Styles.coverBlue,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      stretchModes: const [
                        StretchMode.zoomBackground,
                      ],
                      background: Stack(
                        children: [
                          Positioned.fill(
                            child: MyNetworkImage(
                              imgUrl:
                                  UserManager.instance.state.user.value.avatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              SizeConfig.bodyPadding,
                              SizeConfig.topMargin + kToolbarHeight,
                              SizeConfig.bodyPadding,
                              SizeConfig.bodyPadding,
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [],
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
                                url: UserManager
                                    .instance.state.user.value.avatar,
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
                                    UserManager.instance.state.user.value.name,
                                    style: Styles.textBold(18.w)
                                        .copyWith(color: Styles.blackText),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'uid: ${UserManager.instance.state.user.value.uid}',
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
                                UserManager.instance.state.user.value.sex == 1
                                    ? Icons.male
                                    : Icons.female,
                                color: Styles.lightBlue,
                                size: 14.w,
                              ),
                              Text(
                                UserManager.instance.state.user.value.sex == 1
                                    ? '男'
                                    : '女',
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
          Positioned(
            child: Container(
              height: 54 + SizeConfig.topMargin,
              color:
                  Styles.coverBlue.withOpacity(state.scrollColorOpacity.value),
            ),
          ),
        ],
      ),
    );
  }
}
