import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../../model/resp/apply_resp.dart';
import '../../model/resp/group_apply_list_resp.dart';
import '../../widgets/image/round_avatar.dart';
import 'group_notice_logic.dart';

class GroupNoticePage extends StatelessWidget {
  GroupNoticePage({super.key});

  final logic = Get.put(GroupNoticeLogic());
  final state = Get.find<GroupNoticeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.white,
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: Text(
          '群通知',
          style: Styles.textFiraNormal(18.w),
        ),
        actions: [
          SizedBox(
            width: SizeConfig.bodyPadding,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '入群申请',
                        style: Styles.textFiraBold(12.w),
                      ),
                    ],
                  ),
                  Expanded(child: _buildApplyList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyList() {
    return EasyRefresh.builder(
      controller: state.refreshController,
      onRefresh: () => logic.refreshGroupApplyList(isRefresh: true),
      onLoad: () => logic.refreshGroupApplyList(isRefresh: false),
      childBuilder: (context, physics) {
        return Obx(() {
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: physics,
            itemCount: state.applyList.length,
            itemBuilder: (context, index) {
              return _buildApplyCell(state.applyList[index]);
            },
          );
        });
      },
    );
  }

  Widget _buildApplyCell(GroupApplyModel apply) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.w, 0, 8.w),
      child: Row(
        children: [
          RoundAvatar(
            height: 48.w,
            url: apply.avatar,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apply.name,
                  style: Styles.textFiraBold(16.w),
                ),
                SizedBox(height: 4.w),
                Text(
                  '申请加入：${apply.groupName}',
                  style: Styles.textFiraNormal(14.w)
                      .copyWith(color: Styles.greyText),
                ),
                SizedBox(height: 4.w),
                Text(
                  apply.message,
                  style: Styles.textFiraNormal(14.w)
                      .copyWith(color: Styles.greyText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 添加同意和拒绝按钮
          if (apply.status == ApplyStatus.accepted.code) // 已同意
            Text(
              '已同意',
              style:
                  Styles.textFiraNormal(14.w).copyWith(color: Styles.greyText),
            )
          else if (apply.status == ApplyStatus.rejected.code) // 已拒绝
            Text(
              '已拒绝',
              style:
                  Styles.textFiraNormal(14.w).copyWith(color: Styles.greyText),
            )
          else // 待处理
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => logic.approve(apply, true),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                    decoration: BoxDecoration(
                      color: Styles.normalBlue,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text(
                      '同意',
                      style: Styles.textFiraNormal(14.w)
                          .copyWith(color: Styles.white),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => logic.approve(apply, false),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                    decoration: BoxDecoration(
                      color: Styles.greyBgColor,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text(
                      '拒绝',
                      style: Styles.textFiraNormal(14.w)
                          .copyWith(color: Styles.greyText),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
