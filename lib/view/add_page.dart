import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:memo/components/neumorphic_card.dart';
import '../components/constantes.dart';
import '../controller/home_controlle.dart';
import '../controller/theme_controller.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  static String route = 'add-page';

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.titlecontroller.clear();
    controller.desccontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildDateTimeRow(),
              const SizedBox(height: 10),
              buildDescriptionInput(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 80),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: AppBar(
          elevation: 0,
          excludeHeaderSemantics: true,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdLable
                : Constants.clLable,
          ),
          title: buildTitleInput(),
        ),
      ),
    );
  }

  Widget buildTitleInput() {
    return TextFormField(
      controller: controller.titlecontroller,
      cursorColor: Constants.clMaincolor,
      maxLength: 50,
      decoration: InputDecoration(
        counterText: '',
        hintText: 'Title',
        hintStyle: TextStyle(fontSize: 16.sp, color: Constants.clLable),
        fillColor: Colors.transparent,
        filled: true,
        border: InputBorder.none,
        errorStyle: const TextStyle(height: 0),
      ),
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Get.find<ThemeController>().isDark()
            ? Constants.cdMaintxt
            : Constants.clMaintxt,
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value != null && value.isEmpty) {
          controller.handleError('Title is empty', context);
          return '';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMd().format(DateTime.now()),
          style: TextStyle(
            color: Get.find<ThemeController>().isDark()
                ? Constants.cdMaintxt
                : Constants.clMaintxt,
          ),
        ),
        GestureDetector(
          onTap: () {
            final isValid = formKey.currentState!;
            if (isValid.validate()) {
              controller.createMemo();
              Navigator.pop(context);
            }
          },
          child: NeumorphicCard(
            isCard: false,
            child: SizedBox(
              width: 80.w,
              height: 30.h,
              child: Center(
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: Constants.clMaincolor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDescriptionInput() {
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
        controller: controller.desccontroller,
        cursorColor: Constants.clMaincolor,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(fontSize: 16.sp, color: Constants.clLable),
          fillColor: Colors.transparent,
          filled: true,
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0),
        ),
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
}
