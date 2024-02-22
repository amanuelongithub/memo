import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/components/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeMode themeMode = ThemeMode.dark;
  final bool prefThem;
// for onborading
  final controller = PageController();
  bool isLastPage = false;

  ThemeController({required this.prefThem}) {
    themeMode = prefThem ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isOn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (isOn) {
      themeMode = ThemeMode.dark;
      preferences.setBool('isDark', true);
    } else {
      themeMode = ThemeMode.light;
      preferences.setBool('isDark', false);
    }
    update();
  }

  bool isDark() {
    return isDarkMode;
  }

 

  pageIndex(int index) {
    isLastPage = index == 1;
    update();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
    colorScheme: const ColorScheme.light().copyWith(
      primary: Constants.clMaincolor,
      surfaceTint: Colors.transparent,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Quicksand',
      ),
    ),
    iconTheme: const IconThemeData(color: Constants.clLable),
  );
  static final lightTheme = ThemeData(
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: Constants.clbg,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Constants.clMaincolor,
      surfaceTint: Colors.transparent,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Quicksand',
      ),
    ),
    iconTheme: const IconThemeData(color: Constants.clLable),
  );
}
