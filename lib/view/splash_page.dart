import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:memo/components/constantes.dart';
import 'package:memo/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/theme_controller.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static String route = 'splash-page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  bool showHome = false;

  @override
  void initState() {
    super.initState();
    getShowHome();
    init();
  }

  void init() {
    lottieController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    lottieController.forward();
    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(
            context, showHome ? HomePage.route : OnBoardingPage.route);
      }
    });
  }

  void getShowHome() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      showHome = preferences.getBool('showHome') ?? false;
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.find<ThemeController>().isDark()
          ? Constants.cdbg
          : Constants.clbg,
      body: Center(
        child: Lottie.asset(
          Get.find<ThemeController>().isDark()
              ? 'assets/json/dark_splash.json'
              : 'assets/json/light_splash.json',
          repeat: false,
          controller: lottieController,
          onLoaded: (composition) {
            lottieController.duration = composition.duration;
          },
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
