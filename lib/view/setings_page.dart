import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:memo/components/neumorphic_card.dart';
import 'package:memo/controller/home_controlle.dart';
import 'package:memo/controller/theme_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../components/constantes.dart';
import '../components/dialogbox.dart';
import 'home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static String route = 'settings-page';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(10));
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
        appBar: appBar(context, inputBorder),
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      settings(
                          title: 'Theme',
                          trailing: Icons.theater_comedy,
                          subtitle: Get.find<ThemeController>().isDark()
                              ? 'dark mode'
                              : 'light mode',
                          onPressed: () async {
                            bool isDark = Get.find<ThemeController>().isDark();

                            Get.find<ThemeController>().toggleTheme(!isDark);
                          },
                          duration: 1600),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'Notification',
                          subtitle: 'Enabled',
                          trailing: Icons.notifications_none,
                          duration: 1700),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'Change Languages',
                          trailing: Icons.language_outlined,
                          subtitle: 'English',
                          duration: 1850),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'Clear all memo',
                          trailing: Icons.delete_outline,
                          onPressed: _.filteredMemos.isNotEmpty
                              ? () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => DialogBox(
                                            msg:
                                                'Are you sure you want to delete all memos?',
                                            onPressed: () async {
                                              _.enableLoading();
                                              await _.deleteAllMemo();
                                              _.disableLoading();
                                              if (mounted) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        HomePage.route,
                                                        (route) => false);
                                              }
                                            },
                                          ));
                                }
                              : null,
                          duration: 2200),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'New futures',
                          trailing: Icons.align_vertical_bottom_outlined,
                          duration: 1900),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'Feedback',
                          trailing: Icons.feedback_outlined,
                          duration: 2000),
                      SizedBox(height: 15.spMax),
                      settings(
                          title: 'About',
                          trailing: Icons.developer_board_rounded,
                          duration: 2100),
                      const Spacer(),
                      versionFuture(),
                      SafeArea(
                        child: SizedBox(height: 20.h),
                      )
                    ]),
              ),
            ),
          );
        }),
      );
    });
  }

  FutureBuilder<PackageInfo> versionFuture() {
    return FutureBuilder(
      future: getPackageInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.black);
        } else if (snapshot.hasError) {
          return Text('Error fetching package info: ${snapshot.error}');
        } else {
          final packageInfo = snapshot.data!;
          return version(packageInfo);
        }
      },
    );
  }

  version(PackageInfo packageInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          packageInfo.appName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdLable
                : Constants.clLable,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          packageInfo.version,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Constants.cdLable,
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© Copyright ${DateFormat('yyyy').format(DateTime.now())}',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Constants.cdLable),
            )
          ],
        ),
      ],
    );
  }

  line() {
    return Column(
      children: [
        SizedBox(height: 10.spMax),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 2,
          ),
        ),
        SizedBox(height: 10.spMax),
      ],
    );
  }

  settings(
      {required String title,
      String? subtitle,
      required IconData trailing,
      VoidCallback? onPressed,
      required int duration}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: NeumorphicCard(
          child: SizedBox(
        width: double.infinity,
        height: 65.spMin,
        child: Center(
            child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: onPressed == null
                  ? const Color.fromARGB(255, 168, 168, 168)
                  : Get.find<ThemeController>().isDark()
                      ? Colors.white
                      : const Color.fromARGB(221, 49, 49, 49),
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: onPressed == null
                        ? const Color.fromARGB(255, 168, 168, 168)
                        : Get.find<ThemeController>().isDark()
                            ? Constants.cdSeccolor
                            : Constants.clSeccolor,
                  ),
                )
              : null,
          trailing: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.ease,
              duration: Duration(milliseconds: duration),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: NeumorphicCard(
                isCard: false,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    trailing,
                    color: onPressed != null
                        ? Constants.cdMaincolor
                        : Get.find<ThemeController>().isDark()
                            ? Constants.clSeccolor
                            : Constants.cdSeccolor,
                  ),
                ),
              )),
          onTap: onPressed,
        )),
      )),
    );
  }

  appBar(BuildContext context, OutlineInputBorder inputBorder) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 110),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            AppBar(
              toolbarHeight: 83.sp,
              leading: BackButton(
                color: Get.find<ThemeController>().isDark()
                    ? Constants.cdLable
                    : Constants.clLable,
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'S',
                              style: TextStyle(
                                fontSize: 25.sp,
                                color: Constants.clMaincolor,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'ettings',
                              style: TextStyle(
                                fontSize: 25.sp,
                                color: Get.find<ThemeController>().isDark()
                                    ? Constants.cdSeccolor
                                    : Constants.clSeccolor,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ])),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
