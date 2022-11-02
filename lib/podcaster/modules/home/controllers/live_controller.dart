import 'dart:developer';
import 'dart:io';

import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam_podcaster/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam_podcaster/podcaster/data/repository/podcaster_impl.dart';
import 'package:puthagam_podcaster/podcaster/domain/params/podcast/go_live_podcast_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/params/podcast/podcast_status_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/repository/ipodcaster_repository.dart';
import 'package:puthagam_podcaster/podcaster/modules/main/controllers/main_controller.dart';

import '../../../core/utils/app_utils.dart';

class LiveController extends GetxController {
  final count = 0.obs;
  FlutterRtmpStreamer? streamer;
  final showPlayer = false.obs;
  final recording = false.obs;
  final audioPath = "".obs;
  late final RecorderController recorderController;
  final IPodcasterRepository repository = PodcasterRepositoryImpl();
  final MainController mainController = Get.find();
  final params = PodcastStatusParams();
  late final GoLivePodcastParams args;

  @override
  void onInit() {
    super.onInit();
    recorderController = RecorderController();
    log("author id ${LocalStorage.readAuthorID()}");
    getPodcastStatusParams();
  }

  startStreaming() async {
    try {
      Get.dialog(buildLoadingIndicator(), barrierDismissible: false);
      log("params ${params.toJson()}");
      final response = await repository.goLive(params);
      Get.back();
      if (response.data != null) {
        recording.value = true;
        await recorderController.record();
        streamer?.startStream(
            uri: "rtmp://65.20.74.140/live", streamName: args.episodeId!);
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  getPodcastStatusParams() {
    args = Get.arguments;
    params.autorId = LocalStorage.readAuthorID();
    params.episodeId = args.episodeId;
    params.podcastId = args.podcastId;
  }

  stopStreaming() async {
    try {
      Get.dialog(buildLoadingIndicator(), barrierDismissible: false);
      final response = await repository.exitLive(params);
      Get.back();
      if (response.data != null) {
        recording.value = false;
        showPlayer.value = true;
        audioPath.value = await recorderController.stop() ?? "";
        streamer?.stopStream();
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  uploadAudio() async {
    try {
      buildDialogLoadingIndicator();
      File file = File(audioPath.value);
      final player = AudioPlayer();
      var duration = await player.setUrl(file.path);
      final minutes = (duration!.inSeconds / 60).roundToDouble();
      final response = await repository.uploadAudio(LocalStorage.readAuthorID(),
          params.podcastId!, params.episodeId!, minutes, file);
      Get.back();
      if (response.data != null) {
        showToastMessage(title: "Success", message: "Episode uploaded");
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  void increment() => count.value++;
}
