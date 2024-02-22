import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/controller/home_controlle.dart';
import 'package:memo/controller/theme_controller.dart';
import 'package:memo/routes.dart';
import 'package:memo/view/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool themeData = await getThemeData();
  runApp(MyApp(themeData: themeData));
}

Future<bool> getThemeData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('isDark') ?? false;
}

class MyApp extends StatefulWidget {
  final bool themeData;
  const MyApp({super.key, required this.themeData});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<AnimatedListState> myListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(ThemeController(prefThem: widget.themeData));

    return GetBuilder<ThemeController>(builder: (_) {
      final currentTheme = _.themeMode;
      return ScreenUtilInit(
          designSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          builder: (context, child) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              themeMode: currentTheme,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              initialRoute: SplashPage.route,
              routes: getRoutes(),
            );
          });
    });
  }
}
