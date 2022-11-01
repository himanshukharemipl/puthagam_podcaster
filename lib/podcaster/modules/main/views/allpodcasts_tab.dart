import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/modules/main/controllers/main_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/widgets/build_loading.dart';
import '../../../data/datasources/local/app_database.dart';
import 'build_podcast.dart';

class BuildAllEpisodesTab extends StatelessWidget {
  BuildAllEpisodesTab({super.key});
  final MainController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          20.heightBox,
          Obx(() {
            return controller.loading.isTrue
                ? buildLoadingIndicator()
                : ListView.builder(
                    itemCount: controller.allPodcasts.length,
                    itemBuilder: (ctx, index) {
                      final podcast = controller.allPodcasts[index];
                      return BuildPodcast(
                          controller: controller, podcast: podcast);
                    }).expand();
          })
        ],
      ).h(double.infinity).marginAll(10)),
    );
  }
}
