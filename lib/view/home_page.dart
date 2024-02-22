import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:memo/components/main_logo.dart';
import 'package:memo/components/neumorphic_card.dart';
import 'package:memo/controller/home_controlle.dart';
import 'package:memo/view/add_page.dart';
import 'package:memo/view/detail_page.dart';
import 'package:memo/view/setings_page.dart';
import '../components/animated_text.dart';
import '../components/constantes.dart';
import '../components/memo_card.dart';
import '../controller/theme_controller.dart';
import '../model/memo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String route = 'home-page';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Scaffold(
                appBar: appBar(context),
                body: _.memos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/json/empty.json',
                              repeat: true,
                              height: 120,
                              width: 120,
                            ),
                            const Text(
                              "Empty Memo",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(203, 131, 131, 131)),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: PageView(
                            controller: _.pageController,
                            onPageChanged: (index) => _.onPageChange(index),
                            children: [
                              buildPage0(_),
                              buildPage1(_),
                              buildPage2(_)
                            ]),
                      )),
              ),
              _.isLoading
                  ? const CircularProgressIndicator(
                      color: Constants.cdMaincolor,
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  buildPage0(HomeController _) {
    return ListView.separated(
      itemCount: _.filteredMemos.length,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      itemBuilder: (context, index) {
        final memo = _.filteredMemos[index];
        return GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            _.loadMemo(memo);
            Navigator.pushNamed(context, DetailPage.route);
          },
          child: MemoCard(
            memo: memo,
            index: index,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: 12.h,
      ),
    );
  }

  buildPage1(HomeController _) {
    List<Memo> memos =
        _.filteredMemos.where((memo) => memo.isDone == false).toList();

    return ListView.separated(
      itemCount: memos.length,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      itemBuilder: (context, index) {
        final memo = memos[index];
        return GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            _.loadMemo(memo);
            Navigator.pushNamed(context, DetailPage.route);
          },
          child: MemoCard(
            memo: memo,
            index: index,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: 12.h,
      ),
    );
  }

  buildPage2(HomeController _) {
    List<Memo> memos =
        _.filteredMemos.where((memo) => memo.isDone == true).toList();

    return ListView.separated(
      itemCount: memos.length,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      itemBuilder: (context, index) {
        final memo = memos[index];
        return GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            _.loadMemo(memo);
            Navigator.pushNamed(context, DetailPage.route);
          },
          child: MemoCard(
            memo: memo,
            index: index,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: 12.h,
      ),
    );
  }

  appBar(
    BuildContext context,
  ) {
    final _ = Get.find<HomeController>();
    return PreferredSize(
      preferredSize: Size(double.infinity, 250.sp),
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 83.sp,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MainLogo(
                    isBig: true,
                  ),
                  NeumorphicCard(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsPage.route);
                    },
                    isCard: false,
                    child: SizedBox(
                      width: 80.w,
                      height: 30.h,
                      child: Center(
                        child: AnimatedText(
                            text: Text(
                              'Setting',
                              style: TextStyle(
                                color: Get.find<ThemeController>().isDark()
                                    ? Constants.cdSeccolor
                                    : Constants.clSeccolor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration: 800),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          searchBar(context),
          const Spacer(),
          if (_.filteredMemos.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                height: 60.h,
                width: double.infinity,
                child: NeumorphicCard(
                    isCard: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tabButton(
                            title: 'All',
                            pageNum: 0,
                            selectedPage: _.selectPage,
                            onPressed: () {
                              _.pageController.jumpToPage(0);
                            }),
                        tabButton(
                            title: 'Task',
                            pageNum: 1,
                            selectedPage: _.selectPage,
                            onPressed: () {
                              _.pageController.jumpToPage(1);
                            }),
                        tabButton(
                            title: 'Done',
                            pageNum: 2,
                            selectedPage: _.selectPage,
                            onPressed: () {
                              _.pageController.jumpToPage(2);
                            }),
                      ],
                    )),
              ),
            )
          ],
          const Spacer(),
        ],
      ),
    );
  }

  tabButton(
      {required String title,
      required int pageNum,
      required int selectedPage,
      required VoidCallback onPressed}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: double.infinity,
          child: Container(
            padding: EdgeInsets.all(8.r),
            child: NeumorphicCard(
                isCard: selectedPage == pageNum ? false : true,
                child: Center(
                    child: Text(
                  title,
                  style: TextStyle(
                      color: Get.find<ThemeController>().isDark()
                          ? Constants.clbg
                          : Constants.cdbg),
                ))),
          ),
        ),
      ),
    );
  }

  searchBar(context) {
    final _ = Get.find<HomeController>();

    final child = TextField(
      cursorColor: Constants.clLable,
      decoration: InputDecoration(
        contentPadding: REdgeInsets.all(15),
        hintText: 'Search memo',
        hintStyle: TextStyle(
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdLable
                : Constants.clLable,
            fontSize: 14.sp),
        prefixIcon: Icon(
          Icons.search,
          color:
              Get.find<ThemeController>().isDark() ? Constants.cdLable : null,
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        _.searchMemo(value);
      },
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Get.find<ThemeController>().isDark()
            ? Constants.clLable
            : Constants.cdLable,
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: NeumorphicCard(
              child: child,
            ),
          ),
          SizedBox(width: 5.sp),
          NeumorphicCard(child: createMemo(context)),
        ],
      ),
    );
  }

  createMemo(context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AddPage.route);
      },
      child: Container(
          padding: EdgeInsets.all(15.5.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.sp),
          ),
          child: const Text(
            'Create',
            style: TextStyle(
              color: Constants.clMaincolor,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
