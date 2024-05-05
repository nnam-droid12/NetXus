
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:netxus/models/user_model.dart';

class HomeController extends GetxController {
  late User user;
  late TextEditingController phoneTxtCon;
  @override
  void onInit() {
    phoneTxtCon = TextEditingController();
    user = User(
        name: 'Jude Boachie',
        energyUsed2day: 26.8,
        energyUsedInMonth: 325.37,
      );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void topUp() {
    print('topup');
  }

  void confirm() {
    print('confirm');
  }

  void cancel() {
    print('cancel');
  }
}
