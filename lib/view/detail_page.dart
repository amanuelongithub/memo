import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:memo/components/dialogbox.dart';
import 'package:memo/components/neumorphic_card.dart';
import 'package:memo/model/memo.dart';
import 'package:intl/intl.dart';
import 'package:memo/view/home_page.dart';
import '../components/constantes.dart';
import '../controller/home_controlle.dart';
import '../controller/theme_controller.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  static String route = 'detail-page';

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Memo? memo;
  bool startEdited = false;
  final formKey = GlobalKey<FormState>();
  final _ = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    memo = _.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: WillPopScope(
        onWillPop: () async {
          startEdited = false;
          return true;
        },
        child: Scaffold(
            appBar: buildAppBar(_, context),
            body: _.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : memo != null
                    ? Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildHeader(context),
                              SizedBox(height: 10.h),
                              buildDescription(_, context),
                              SizedBox(height: 10.h),
                              buildFooter()
                            ],
                          ),
                        ),
                      )
                    : const Center(child: Text('Memo empty'))),
      ),
    );
  }

  buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMd().format(memo!.createdTime),
            style: TextStyle(
              color: Get.find<ThemeController>().isDark()
                  ? Constants.cdMaintxt
                  : Constants.clMaintxt,
            ),
          ),
          if (memo != null) ...[
            Row(children: [
              NeumorphicCard(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => DialogBox(
                            msg: memo!.isDone
                                ? 'Unarchive Confirmation?'
                                : 'Confirm Archiving Memo?',
                            color: memo!.isDone
                                ? Constants.clArchive
                                : Constants.clMaincolor,
                            onPressed: () async {
                              _.enableLoading();
                              await _.addToDoneList(memo!, !memo!.isDone);
                              _.startEdited = false;
                              _.disableLoading();
                              if (mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, HomePage.route, (route) => false);
                              }
                            },
                          ));
                },
                isCard: false,
                child: SizedBox(
                  width: 80.w,
                  height: 30.h,
                  child: Center(
                    child: Text(
                      "Archive",
                      style: TextStyle(
                        color: Constants.clArchive,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.sp),
              NeumorphicCard(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => DialogBox(
                            msg: 'Are you sure you want to delete this memo?',
                            onPressed: () async {
                              _.enableLoading();
                              await _.deleteMemo(memo!.id!);
                              _.startEdited = false;
                              _.disableLoading();
                              if (mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, HomePage.route, (route) => false);
                              }
                            },
                          ));
                },
                isCard: false,
                child: SizedBox(
                  width: 80.w,
                  height: 30.h,
                  child: Center(
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 80, 80),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (startEdited) ...[
                SizedBox(width: 8.sp),
                GestureDetector(
                    onTap: () async {
                      final isValid = formKey.currentState!;
                      if (isValid.validate()) {
                        await _.updateMemo();
                        _.startEdited = false;
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: NeumorphicCard(
                      isCard: false,
                      child: SizedBox(
                        width: 80.w,
                        height: 30.h,
                        child: Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Constants.clMaincolor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ))
              ]
            ])
          ]
        ],
      ),
    );
  }

  buildAppBar(HomeController _, BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 60),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              _.startEdited = false;
              Navigator.pop(context);
            },
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdLable
                : Constants.clLable,
          ),
          title: TextFormField(
            controller: _.titlecontroller,
            cursorColor: Constants.clMaincolor,
            maxLength: 50,
            decoration: const InputDecoration(
              counterText: '',
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              errorStyle: TextStyle(height: 0),
            ),
            onChanged: (value) {
              setState(() {
                startEdited = true;
              });
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                _.handleError('Title is empty', context);
                return '';
              } else {
                return null;
              }
            },
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Get.find<ThemeController>().isDark()
                  ? Constants.cdMaintxt
                  : Constants.clMaintxt,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        ),
      ),
    );
  }

  buildDescription(HomeController _, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.find<ThemeController>().isDark()
            ? Constants.cdfill
            : Constants.clfill,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _.desccontroller,
        cursorColor: Constants.clMaincolor,
        maxLines: null,
        decoration: const InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          border: InputBorder.none,
          errorStyle: TextStyle(height: 0),
        ),
        onChanged: (value) {
          setState(() {
            startEdited = true;
          });
        },
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Get.find<ThemeController>().isDark()
              ? Constants.cdMaintxt
              : Constants.clMaintxt,
        ),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  buildFooter() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              memo!.isDone ? '# Done' : '# Todo',
              style: TextStyle(
                color: memo!.isDone ? Constants.clArchive : Constants.clHashtag,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Last updated date: ',
                style: TextStyle(
                  color: Constants.cdLable,
                  fontSize: 10.sp,
                ),
              ),
              if (memo!.lastUpdated != null) ...[
                TextSpan(
                  text: DateFormat.yMMMd().format(memo!.lastUpdated!),
                  style: TextStyle(
                    color: Constants.cdLable,
                    fontSize: 10.sp,
                  ),
                ),
              ]
            ])),
          ]),
    );
  }
}
