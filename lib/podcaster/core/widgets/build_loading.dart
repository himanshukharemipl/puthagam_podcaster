import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

buildLoadingIndicator() {
  return const CupertinoActivityIndicator().centered();
}

buildDialogLoadingIndicator() {
  return Get.dialog(buildLoadingIndicator(), barrierDismissible: false);
}
