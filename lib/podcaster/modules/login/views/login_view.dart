import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/app_buttons.dart';
import 'package:puthagam_podcaster/gen/assets.gen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            20.heightBox,
            Image.asset(
              Assets.images.logo.path,
              width: 200,
              height: 200,
            ),
            20.heightBox,
            VxTextField(
              hint: "Enter Email",
              controller: controller.email,
              contentPaddingLeft: 10,
            ),
            20.heightBox,
            VxTextField(
              hint: "Enter Password",
              controller: controller.password,
              contentPaddingLeft: 10,
              isPassword: true,
            ),
            50.heightBox,
            Obx(() {
              return controller.loading.isFalse
                  ? ButtonPrimary(
                      title: "Login",
                      onPressed: () {
                        controller.login();
                      })
                  : const ButtonLoading();
            })
          ],
        ).marginAll(10),
      )),
    );
  }
}
