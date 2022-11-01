import 'dart:developer';
import 'dart:io';
import 'package:audio_picker/audio_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puthagam_podcaster/podcaster/core/utils/app_utils.dart';
import 'package:puthagam_podcaster/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam_podcaster/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam_podcaster/podcaster/data/repository/podcaster_impl.dart';
import 'package:puthagam_podcaster/podcaster/domain/entities/episodes/get_episodes_response/datum.dart'
    as episode;
import 'package:puthagam_podcaster/podcaster/domain/params/podcast/get_podcast_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/repository/ipodcaster_repository.dart';

import '../../../domain/entities/podcasts/get_podcast_response/datum.dart';

import 'package:puthagam_podcaster/podcaster/domain/entities/upcoming/upcoming_episodes_response/datum.dart'
    as upcoming;

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final count = 0.obs;
  final IPodcasterRepository repository = PodcasterRepositoryImpl();
  final loading = false.obs;
  final allPodcasts = <Datum>[].obs;
  final upcomingPodcasts = <upcoming.Datum>[].obs;
  final allEpisodes = <episode.Datum>[].obs;
  final episodesLoading = false.obs;

  final upcomingLoading = false.obs;

  String selectedPodcast = "";
  String selectEpisode = "";
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    log("author id ${LocalStorage.readAuthorID()}");
    tabController = TabController(length: 2, vsync: this);
    getAllPodcasts();
    getAllUpcomingPodcast();
  }

  getAllPodcasts() async {
    try {
      loading.value = true;
      final params = GetPodcastParams(start: 0, length: 10);
      final response = await repository.getPodcasts(params);
      loading.value = false;
      if (response.data != null) {
        allPodcasts.value = response.data?.data ?? [];
      }
    } catch (e) {
      log("e $e");
      loading.value = false;
    }
  }

  getAllUpcomingPodcast() async {
    try {
      upcomingLoading.value = true;
      final response = await repository.getUpcomingEpisodes();
      upcomingLoading.value = false;
      if (response.data != null) {
        upcomingPodcasts.value = response.data?.data ?? [];
      }
    } catch (e) {
      log("e $e");
      upcomingLoading.value = false;
    }
  }

  getAllEpisodes(String podcast) async {
    try {
      selectedPodcast = podcast;
      episodesLoading.value = true;
      final response = await repository.getEpisodeByPodcasts(podcast);
      episodesLoading.value = false;
      if (response.data != null) {
        allEpisodes.value = response.data?.data ?? [];
      }
    } catch (e) {
      log("e $e");
      episodesLoading.value = false;
    }
  }

  uploadAudio(String episode) async {
    try {
      String path = await AudioPicker.pickAudio();
      buildDialogLoadingIndicator();
      File file = File(path);
      final player = AudioPlayer();
      var duration = await player.setUrl(file.path);
      final minutes = (duration!.inSeconds / 60).roundToDouble();
      final response = await repository.uploadAudio(
          LocalStorage.readAuthorID(), selectedPodcast, episode, minutes, file);
      Get.back();
      if (response.data != null) {
        showToastMessage(title: "Success", message: "Episode uploaded");
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  getDate(String date) {
    return DateFormat("dd MMM,hh:mm a").format(DateTime.tryParse(date)!);
  }

  bool showEpisodeRecordBtn(String startDate, String endDate) {
    bool showRecord = false;
    final currentDateTime = DateTime.now();
    final startDatetime = DateTime.parse(startDate);
    final endDatetime = DateTime.parse(endDate);
    if (currentDateTime.isAfter(startDatetime) &&
        currentDateTime.isBefore(endDatetime)) {
      showRecord = true;
    }
    return showRecord;
  }

  bool showEpisodeUploadBtn(String endDate) {
    bool showUpload = false;
    final currentDateTime = DateTime.now();
    final endDatetime = DateTime.parse(endDate);
    if (currentDateTime.isAfter(endDatetime)) {
      showUpload = true;
    }
    return showUpload;
  }

  String _daysBetween(DateTime from, DateTime to) {
    final days = (to.difference(from).inDays);
    final hours = (to.difference(from).inHours);
    final minuts = (to.difference(from).inMinutes);

    if (days > 0) {
      return "${days.round()} days left";
    } else if (hours > 0) {
      return "${hours.round()} hours left";
    } else {
      return "${minuts.round()} mins left";
    }
  }

  String findRemainingTime(
    String startDate,
  ) {
    final startDatetime = DateTime.parse(startDate);
    return _daysBetween(DateTime.now(), startDatetime);
  }
}
