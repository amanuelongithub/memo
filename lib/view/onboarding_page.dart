import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/components/constantes.dart';
import 'package:memo/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controller/theme_controller.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  static String route = 'onboarding-page';

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (_) {
      return Scaffold(
        body: Container(
            padding: EdgeInsets.only(bottom: 10.sp),
            child: Container(
              color: _.isDark() ? Constants.cdbg : Constants.clbg,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Center(
                          child: Image.asset(
                    'assets/img/page1.png',
                    scale: 4,
                  ))),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().screenHeight / 2,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: PageView(
                        controller: _.controller,
                        children: [
                          pageOne(_),
                          pageTwo(_, context),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      );
    });
  }

  Column pageOne(ThemeController _) {
    return Column(
      children: [
        const Spacer(
          flex: 1,
        ),
        SmoothPageIndicator(
          controller: _.controller,
          count: 2,
          effect: WormEffect(
            dotWidth: 18.sp,
            dotHeight: 5.sp,
            spacing: 10.sp,
            dotColor: Constants.clSeccolor,
            activeDotColor: Constants.clMaincolor,
          ),
        ),
        const Spacer(
          flex: 2,
        ),
        Text(
          'Let\'s More Prodauctive',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          child: Text(
            'Get organized, get things done. Make every minute count with our intuitive task management system',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Constants.clMaintxt),
          ),
        ),
        const Spacer(flex: 4),
        OutlinedButton(
          onPressed: () async {
            _.controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Constants.clMaincolor),
            minimumSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
          child: Text(
            'Next',
            style: TextStyle(
              color: Constants.cdMaincolor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }

  Column pageTwo(ThemeController _, BuildContext context) {
    return Column(
      children: [
        const Spacer(
          flex: 1,
        ),
        SmoothPageIndicator(
          controller: _.controller,
          count: 2,
          effect: WormEffect(
            dotWidth: 18.sp,
            dotHeight: 5.sp,
            spacing: 10.sp,
            dotColor: Constants.clSeccolor,
            activeDotColor: Constants.clMaincolor,
          ),
        ),
        const Spacer(
          flex: 2,
        ),
        Text(
          'Get productive, effortlessly',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          child: Text(
            'Unlock your potential, unleash your focus.Effortless productivity starts now',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, color: Constants.clMaintxt),
          ),
        ),
        const Spacer(flex: 4),
        TextButton(
          onPressed: () async {
            final pref = await SharedPreferences.getInstance();
            pref.setBool('showHome', true);
            if (mounted) {
              Navigator.pushReplacementNamed(context, HomePage.route);
            }
          },
          style: TextButton.styleFrom(
            // backgroundColor: Constants.clMaincolor,
            side: const BorderSide(color: Constants.clMaincolor),
            minimumSize: const Size(150, 50),
            //  minimumSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
          child: Text(
            'Get Strated',
            style: TextStyle(
              color: Constants.clMaincolor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}
