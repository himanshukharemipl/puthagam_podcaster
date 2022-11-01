import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:puthagam_podcaster/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam_podcaster/podcaster/domain/entities/base_response.dart';
import 'package:puthagam_podcaster/podcaster/domain/entities/podcasts/get_podcast_response/get_podcast_response.dart';
import 'package:puthagam_podcaster/podcaster/domain/entities/episodes/get_episodes_response/get_episodes_response.dart';
import 'package:puthagam_podcaster/podcaster/core/utils/app_utils.dart';
import 'package:puthagam_podcaster/podcaster/domain/entities/upcoming/upcoming_episodes_response/upcoming_episodes_response.dart';
import 'package:puthagam_podcaster/podcaster/domain/params/podcast/get_podcast_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/params/podcast/podcast_status_params.dart';
import 'package:puthagam_podcaster/podcaster/domain/repository/ipodcaster_repository.dart';

class PodcasterRepositoryImpl extends IPodcasterRepository {
  @override
  Future<DataState<GetEpisodesResponse>> getEpisodeByPodcasts(
      String podcastid) async {
    try {
      log("params $podcastid");
      final httpResponse = await CommonRepository.getApiService()
          .getPodcastEpisodes(LocalStorage.readAuthorID(), podcastid);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetPodcastResponse>> getPodcasts(
      GetPodcastParams params) async {
    try {
      final httpResponse = await CommonRepository.getApiService()
          .getPodcasts(params, LocalStorage.readAuthorID());

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BaseResponse>> exitLive(PodcastStatusParams params) async {
    try {
      final httpResponse =
          await CommonRepository.getApiService().exitLive(params);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BaseResponse>> goLive(PodcastStatusParams params) async {
    try {
      final httpResponse =
          await CommonRepository.getApiService().goLive(params);
      log("httpResponse ${httpResponse.data.toJson()}");
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BaseResponse>> uploadAudio(String userId, String podcastId,
      String episodeId, double audioDuration, File? bookAudio) async {
    try {
      final httpResponse = await CommonRepository.getApiService()
          .uploadAudio(userId, podcastId, episodeId, audioDuration, bookAudio);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<UpcomingEpisodesResponse>> getUpcomingEpisodes() async {
    try {
      final httpResponse = await CommonRepository.getApiService()
          .getUpcomingPodcastEpisodes(LocalStorage.readAuthorID());

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.response,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }
}
