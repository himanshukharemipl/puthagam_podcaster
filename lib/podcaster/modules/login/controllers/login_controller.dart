import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/core/utils/app_utils.dart';
import 'package:puthagam_podcaster/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam_podcaster/podcaster/data/repository/auth_repository_impl.dart';
import 'package:puthagam_podcaster/podcaster/domain/params/auth/login_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/repository/iauth_repository.dart';
import 'package:puthagam_podcaster/podcaster/routes/app_pages.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  final loading = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final IAuthRepositroy repositroy = AuthRepositoryImpl();

  login() async {
    if (email.text.isBlank == true || password.text.isBlank == true) {
      showToastMessage(title: "Error", message: "Fields required");
      return;
    }
    try {
      loading.value = true;
      final params = LoginParams(email: email.text, password: password.text);
      final response = await repositroy.login(params);
      loading.value = false;
      if (response.data != null) {
        showToastMessage(title: "Success", message: "Login Success");
        LocalStorage.saveToken(response.data?.data?.token ?? "");
        LocalStorage.saveAuthorId(response.data?.data?.id ?? "");
        LocalStorage.saveName(response.data?.data?.name ?? "");
        CommonRepository.setApiService();
        Get.offAllNamed(Routes.MAIN);
      }
    } catch (e) {
      log("e $e");
      loading.value = false;
    }
  }

  void increment() => count.value++;
}
