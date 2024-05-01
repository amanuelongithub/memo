import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memo/components/constantes.dart';
import 'package:memo/db/database_helper.dart';
import 'package:memo/model/memo.dart';

import 'theme_controller.dart';

class HomeController extends GetxController {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  PageController pageController = PageController();


  List<Memo> memos = [];
  List<Memo> filteredMemos = [];
  Memo? memo;
  bool isLoading = false;
  bool startEdited = false;
  int selectPage = 0;
  int pageNumber = 0;

  @override
  void onInit() {
    super.onInit();
    feachMemos();
  }

  onPageChange(index) {
    selectPage = index;
    update();
  }

  enableLoading() {
    isLoading = true;
    update();
  }

  disableLoading() {
    isLoading = false;
    update();
  }

  searchMemo(String searchText) {
    String query = searchText.toLowerCase();

    if (query.isEmpty) {
      filteredMemos = List.from(memos);
    } else {
      filteredMemos = memos.where((memo) {
        return memo.title.toLowerCase().contains(query);
      }).toList();
    }
    update();
  }

  handleError(msg, context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
      titleSize: 20,
      messageSize: 17,
      backgroundColor: Get.find<ThemeController>().isDark()
          ? Constants.cdbg
          : const Color.fromARGB(255, 241, 241, 241),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.find<ThemeController>().isDark()
              ? const Color.fromARGB(255, 241, 241, 241)
              : Constants.cdbg,
        ),
      ),
      duration: const Duration(milliseconds: 1500),
    ).show(context);
  }

  loadMemo(Memo selectedMemo) {
    memo = selectedMemo;
    titlecontroller.text = memo!.title;
    desccontroller.text = memo!.desprecation ?? '';
    update();
  }

  createMemo() async {
    isLoading = true;
    final memo = Memo(
      title: titlecontroller.text,
      desprecation: desccontroller.text,
      isDone: false,
      type: 'Work',
      createdTime: DateTime.now(),
      lastUpdated: null,
    );

    await DatabaseHelper.instance.create(memo);
    cleartxts();
    isLoading = false;
    feachMemos();
  }

  cleartxts() {
    titlecontroller.clear();
    desccontroller.clear();
  }

  feachMemos() async {
    isLoading = true;
    memos = await DatabaseHelper.instance.fetchMemos();
    filteredMemos = List.from(memos);
    isLoading = false;
    update();
  }

  updateMemo() async {
    isLoading = true;
    final updatedMemo = memo!.copy(
      title: titlecontroller.text,
      desprecation: desccontroller.text,
      lastUpdated: DateTime.now(),
    );
    await DatabaseHelper.instance.updateMemo(updatedMemo);
    cleartxts();
    isLoading = false;
    feachMemos();
  }

  addToDoneList(Memo selectedMemo, bool value) async {
    isLoading = true;
    final memo = selectedMemo.copy(
      isDone: value,
      lastUpdated: DateTime.now(),
    );
    await DatabaseHelper.instance.updateMemo(memo);
    isLoading = false;
    feachMemos();
    onPageChange(0);
  }

  deleteMemo(int id) async {
    await DatabaseHelper.instance.deleteMemo(id);
    cleartxts();
    isLoading = false;
    feachMemos();
  }

  deleteAllMemo() async {
    await DatabaseHelper.instance.deleteAllMemo();
    isLoading = false;
    feachMemos();
  }
}
