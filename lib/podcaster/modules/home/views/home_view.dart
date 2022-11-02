import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:puthagam_podcaster/podcaster/core/resources/app_resources.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/app_buttons.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/build_network_image.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../gen/assets.gen.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/live_controller.dart';
import 'audio_player.dart';

class HomeView extends GetView<LiveController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "GO LIVE".text.white.make(),
          backgroundColor: themeColor,
          leading: const Icon(Icons.arrow_back_ios_new_rounded).onInkTap(() {
            Get.back();
          }),
        ),
        body: FutureBuilder<FlutterRtmpStreamer>(
            future: FlutterRtmpStreamer.init(StreamingSettings.initial),
            builder: (context, snapshot) {
              controller.streamer = snapshot.data;
              controller.streamer
                  ?.changeStreamingSettings(StreamingSettings.initial);
              if (snapshot.hasError) {
                return MyErrorWidget(error: snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Loader();
              }

              return Column(
                children: [
                  NotificationListener(streamer: controller.streamer!),
                  20.heightBox,
                  controller.args.podcastName!.text.size(18).make(),
                  20.heightBox,
                  BuildNetworkImage(
                      image: controller.args.podcastImage,
                      width: 200,
                      height: 200),
                  20.heightBox,
                  controller.args.episodeName!.text.bold.size(22).make(),
                  50.heightBox,
                  Obx((() {
                    return controller.showPlayer.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: AudioPlayer(
                                  source: controller.audioPath.value,
                                  onDelete: () {
                                    controller.showPlayer.value = false;
                                    controller.audioPath.value = "";
                                    controller.recording.value = false;
                                  },
                                ),
                              ),
                              50.heightBox,
                              ButtonPrimary(
                                  title: "UPLOAD PODCAST",
                                  onPressed: () {
                                    controller.uploadAudio();
                                  })
                            ],
                          )
                        : controller.recording.isTrue
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: AudioWaveforms(
                                      size: const Size(double.infinity, 100),
                                      waveStyle:  WaveStyle(
                                          showMiddleLine: true,
                                          middleLineThickness: 2,
                                          showDurationLabel: true,
                                          middleLineColor: themeColor,
                                          extendWaveform: true,
                                          durationStyle:
                                              TextStyle(color: themeColor),
                                          waveCap: StrokeCap.round),
                                      recorderController:
                                          controller.recorderController,
                                    ),
                                  ),
                                  80.heightBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Icon(
                                        Icons.mic_off_sharp,
                                        color: themeColor,
                                      ),
                                      10.widthBox,
                                      "STOP LIVE".text.color(themeColor).make()
                                    ],
                                  ).onInkTap(() {
                                    controller.stopStreaming();
                                  })
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset(Assets.images.liveRecording,
                                          height: 80)
                                      .onInkTap(() {
                                    controller.startStreaming();
                                  }),
                                  10.heightBox,
                                  "Press LIVE to go live and start streaming"
                                      .text
                                      .gray400
                                      .make()
                                ],
                              );
                  }))
                ],
              ).w(double.infinity).h(double.infinity);
            }));
  }
}

class NotificationListener extends StatelessWidget {
  const NotificationListener({Key? key, required this.streamer})
      : super(key: key);
  final FlutterRtmpStreamer streamer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StreamingNotification>(
        stream: streamer.notificationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(snapshot.data!.description),
                    )));
          }
          return const SizedBox();
        });
  }
}
