import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/components/constantes.dart';
import 'package:memo/components/neumorphic_card.dart';
import 'package:memo/model/memo.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controller/theme_controller.dart';

class MemoCard extends StatelessWidget {
  final Memo memo;
  final int index;
  const MemoCard({super.key, required this.memo, required this.index});

  @override
  Widget build(BuildContext context) {
    final child = buildChild();
    return NeumorphicCard(child: child);
  }

  buildChild() {
    String formattedTime = convertTimeToAgo();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTitle(),
        SizedBox(width: 15.w),
        if (memo.desprecation != '') buildDescription(),
        SizedBox(height: 5.sp),
        buildFooter(formattedTime),
      ]),
    );
  }

  buildDescription() {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.sp,
        left: 0,
        bottom: 5.sp,
      ),
      child: Text(
        memo.desprecation ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Constants.clSubtxt,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  buildTitle() {
    return Text(
      memo.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Get.find<ThemeController>().isDark()
            ? Constants.cdMaintxt
            : Constants.clMaintxt,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildFooter(String formattedTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              memo.isDone ? '# Done' : '# Todo',
              style: TextStyle(
                color: memo.isDone ? Constants.clLable : Constants.clHashtag,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          formattedTime,
          style: TextStyle(
            color: Constants.clago,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  convertTimeToAgo() {
    if (memo.lastUpdated != null) {
      return timeago.format(memo.lastUpdated!);
    } else {
      return timeago.format(memo.createdTime);
    }
  }
}
