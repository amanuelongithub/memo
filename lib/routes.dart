import 'package:flutter/material.dart';
import 'package:memo/view/detail_page.dart';
import 'package:memo/view/onboarding_page.dart';
import 'package:memo/view/setings_page.dart';
import 'package:memo/view/splash_page.dart';
import 'view/add_page.dart';
import 'view/home_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    OnBoardingPage.route: (context) => const OnBoardingPage(),
    SplashPage.route: (context) => const SplashPage(),
    HomePage.route: (context) =>  HomePage(),
    AddPage.route: (context) => const AddPage(),
    DetailPage.route: (context) => const DetailPage(),
    SettingsPage.route: (context) => const SettingsPage(),
  };
}
