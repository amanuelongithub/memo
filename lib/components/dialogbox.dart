import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/components/neumorphic_card.dart';

import '../controller/theme_controller.dart';
import 'constantes.dart';
import 'main_logo.dart';

class DialogBox extends StatelessWidget {
  final String msg;
  final Color? color;
  final VoidCallback onPressed;
  const DialogBox(
      {super.key, required this.msg, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Container(
        padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
        height: 200.h,
        decoration: BoxDecoration(
          color: Get.find<ThemeController>().isDark()
              ? Constants.cdbg
              : Constants.clbg,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            header(),
            message(context),
            btns(context),
          ],
        ),
      ),
    );
  }

  header() {
    return Column(
      children: [
        const MainLogo(),
        SizedBox(height: 5.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Divider(
            thickness: 1,
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdLable
                : Constants.clLable,
          ),
        ),
      ],
    );
  }

  message(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Text(
        msg,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: Get.find<ThemeController>().isDark()
                  ? Constants.cdSeccolor
                  : Constants.clSeccolor,
            ),
      ),
    );
  }

  btns(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 120.sp,
          height: 32.sp,
          child: NeumorphicCard(
              isCard: false,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'cancel',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        color: Get.find<ThemeController>().isDark()
                            ? Constants.cdSeccolor
                            : Constants.clSeccolor,
                      ),
                ),
              )),
        ),
        SizedBox(
            width: 120.sp,
            height: 32.sp,
            child: NeumorphicCard(
                isCard: false,
                onPressed: onPressed,
                child: Center(
                    child: Text(
                  'confirm',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp, color: color ?? Constants.clMaincolor),
                ))))
      ],
    );
  }
}
