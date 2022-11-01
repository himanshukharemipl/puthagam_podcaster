import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
        duration: Duration(seconds: controller.duration),
        child: Center(
          child: Image.asset(
            Assets.images.logo.path,
            width: 200,
          ),
        ),
      ),
    );
  }
}
