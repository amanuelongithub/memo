import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import 'constantes.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final bool isCard;
  final VoidCallback? onPressed;
  const NeumorphicCard({super.key, required this.child, this.isCard = true, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final distance = isCard ? const Offset(3, 3) : const Offset(2, 2);
    double blur = 2.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Get.find<ThemeController>().isDark() ? Constants.cdbg : const Color.fromARGB(255, 241, 241, 241),
            boxShadow: [
              BoxShadow(
                offset: -distance,
                color: Get.find<ThemeController>().isDark() ? const Color.fromARGB(255, 71, 71, 71) : Colors.white,
                blurRadius: blur,
                inset: isCard,
              ),
              BoxShadow(
                offset: distance,
                color: Get.find<ThemeController>().isDark() ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFFA7A9AF),
                blurRadius: blur,
                inset: isCard,
              )
            ],
          ),
          padding: isCard ? null : EdgeInsets.only(bottom: 3.sp),
          child: child),
    );
  }
}
