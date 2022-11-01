import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../gen/assets.gen.dart';
import '../../../core/widgets/build_loading.dart';
import '../../../core/widgets/build_network_image.dart';
import '../../../domain/entities/upcoming/upcoming_episodes_response/datum.dart';
import '../../../domain/params/podcast/go_live_podcast_params.dart';
import '../../../routes/app_pages.dart';
import '../controllers/main_controller.dart';

class BuildUpcomingPocastsTab extends StatelessWidget {
  BuildUpcomingPocastsTab({super.key});

  final MainController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:  Obx(() {
            return controller.upcomingLoading.isTrue
                ? buildLoadingIndicator()
                : controller.upcomingPodcasts.isNotEmpty? ListView.builder(
                    itemCount: controller.upcomingPodcasts.length,
                    itemBuilder: (ctx, index) { 
                      final podcast = controller.upcomingPodcasts[index];
                      return BuildUpcomingPodcast(podcast: podcast);
                    }).expand():"No Upcoming Podcasts found".text.make().centered();
          })),
    );
  }
}

class BuildUpcomingPodcast extends StatelessWidget {
  const BuildUpcomingPodcast({
    Key? key,
    required this.podcast,
  }) : super(key: key);

  final Datum podcast;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final param = GoLivePodcastParams();

        param.episodeId = podcast.episodeId;
        param.podcastId = podcast.podcastId;
        param.episodeName = podcast.episodeName ?? "";
        param.podcastName = podcast.podcastName ?? "";
        param.podcastImage = podcast.podcastImage ?? "";
        Get.toNamed(Routes.HOME, arguments: param);
      },
      leading: BuildNetworkImage(
          image: podcast.podcastImage, width: 50, height: 100),
      minLeadingWidth: 10,
      title: (podcast.podcastName ?? "n/a").text.make(),
      subtitle: (podcast.episodeName ?? "no info available").text.make(),
      trailing:
          Lottie.asset(Assets.images.liveRecording, width: 80).onInkTap(() {}),
    ).box.shadowMd.white.margin(const EdgeInsets.all(10)).rounded.make();
  }
}
