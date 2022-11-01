import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/modules/main/views/build_episodes.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/widgets/build_network_image.dart';
import '../../../domain/entities/podcasts/get_podcast_response/datum.dart';
import '../controllers/main_controller.dart';

class BuildPodcast extends StatelessWidget {
  const BuildPodcast({
    Key? key,
    required this.controller,
    required this.podcast,
  }) : super(key: key);

  final MainController controller;
  final Datum podcast;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        controller.getAllEpisodes(podcast.id!);
        Get.bottomSheet(BuildEpisodes(
          controller: controller,
        ));
      },
      leading: BuildNetworkImage(image: podcast.image, width: 50, height: 100),
      minLeadingWidth: 10,
      title: (podcast.title ?? "n/a").text.make(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (podcast.info ?? "no info available").text.make(),
          10.heightBox,
          "${podcast.chapterCount} episodes".text.make()
        ],
      ).marginOnly(top: 10, bottom: 10),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
    ).box.shadowMd.white.margin(const EdgeInsets.all(10)).rounded.make();
  }
}
