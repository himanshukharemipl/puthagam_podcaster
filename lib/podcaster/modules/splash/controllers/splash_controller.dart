import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam_podcaster/podcaster/routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  final duration = 2;
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: duration), () {
      if (LocalStorage.readToken().isEmpty) {
        Get.offNamed(Routes.LOGIN);
      } else {
        Get.offNamed(Routes.MAIN);
      }
    });
  }

  void increment() => count.value++;
}
