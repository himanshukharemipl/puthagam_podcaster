
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../gen/assets.gen.dart';
import '../../../core/resources/app_resources.dart';
import '../../../core/widgets/build_loading.dart';
import '../../../domain/entities/episodes/get_episodes_response/datum.dart';
import '../../../domain/params/podcast/go_live_podcast_params.dart';
import '../../../routes/app_pages.dart';
import '../controllers/main_controller.dart';

class BuildEpisodes extends StatelessWidget {
  const BuildEpisodes({
    super.key,
    required this.controller,
  });
  final MainController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        "All Episodes".text.bold.size(16).make(),
        10.heightBox,
        Obx(() {
          return controller.episodesLoading.isTrue
              ? buildLoadingIndicator()
              : ListView.separated(
                  itemCount: controller.allEpisodes.length,
                  separatorBuilder: ((context, index) {
                    return const VxDivider();
                  }),
                  itemBuilder: (ctx, index) {
                    final item = controller.allEpisodes[index];
                    return BuildSingleEpisode(
                        episode: item, index: index, controller: controller);
                  }).expand();
        })
      ],
    ).marginAll(10).box.white.topRounded().make();
  }
}

class BuildSingleEpisode extends StatelessWidget {
  const BuildSingleEpisode({
    Key? key,
    required this.episode,
    required this.index,
    required this.controller,
  }) : super(key: key);

  final Datum episode;
  final MainController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ("${index + 1}.${episode.name!}").text.bold.make(),
            5.heightBox,
            (episode.content ?? "n/a").text.gray500.make(),
            10.heightBox,
            "${controller.getDate(episode.startPodcast!)} -  ${controller.getDate(episode.endPodcast!)}"
                .text
                .make()
          ],
        ).expand(),
        controller.showEpisodeRecordBtn(
                    episode.startPodcast!, episode.endPodcast!) ==
                true
            ? Lottie.asset(Assets.images.liveRecording, width: 80).onInkTap(() {
                Get.back();
                final param = GoLivePodcastParams();
                final podcast = controller.allPodcasts
                    .firstWhere((p0) => p0.id == controller.selectedPodcast);
                param.episodeId = episode.id!;
                param.podcastId = controller.selectedPodcast;
                param.episodeName = episode.name ?? "";
                param.podcastName = podcast.title ?? "";
                param.podcastImage = podcast.image ?? "";
                Get.toNamed(Routes.HOME, arguments: param);
              })
            : controller.showEpisodeUploadBtn(episode.endPodcast!)
                ? Row(
                    children: [
                      const Icon(
                        Icons.file_upload_outlined,
                        color: themeColor,
                      ),
                      5.widthBox,
                      "Upload".text.color(themeColor).make()
                    ],
                  ).onInkTap(() {
                    controller.uploadAudio(episode.id!);
                  })
                : controller
                    .findRemainingTime(
                      episode.startPodcast!,
                    )
                    .text
                    .bold
                    .make()
      ],
    ).box.margin(const EdgeInsets.all(10)).make();
  }
}