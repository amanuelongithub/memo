import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memo/components/constantes.dart';

class CircularProg extends StatelessWidget {
  const CircularProg({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color.fromARGB(90, 134, 134, 134),
        alignment: Alignment.center,
        child: Container(
          width: 65.w,
          height: 60.h,
          decoration: BoxDecoration(
              color: Constants.clbg, borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: Constants.clMaincolor,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
    );
  }
}
