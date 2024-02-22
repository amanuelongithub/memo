import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import 'constantes.dart';

class MainLogo extends StatelessWidget {
  final bool isBig;
  const MainLogo({super.key, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (_) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: 'M',
          style: TextStyle(
            fontSize: isBig ? 25.sp : 16.sp,
            color: Constants.clMaincolor,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(
          text: 'emo.',
          style: TextStyle(
            fontSize: isBig ? 25.sp : 16.sp,
            color: _.isDark() ? Constants.cdSeccolor : Constants.clSeccolor,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
        ),
      ]));
    });
  }
}
