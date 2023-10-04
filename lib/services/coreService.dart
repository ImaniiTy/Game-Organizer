import 'dart:developer';

import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/downloadManager.dart';
import 'package:game_organizer/services/localStorage.dart';
import 'package:game_organizer/services/processHelper.dart';
import 'package:game_organizer/services/scrapper.dart';
import 'package:game_organizer/services/sessionManager.dart';

DownloadProcess? downloadProcess;

class CoreService {
  static final CoreService _instance = CoreService._internal();

  factory CoreService() {
    return _instance;
  }

  CoreService._internal();

  Future<void> addGameAndStartDownload(String gamePageUrl, String downloadUrl) async {
    downloadProcess?.source.kill();

    var gamePageUri = Uri.parse(gamePageUrl);

    var gamePage = await Scrapper().getPageParser(gamePageUrl);
    var realDownloadLink = await Scrapper().getRealDownloadUrl(downloadUrl);

    var gameInfoModel = Scrapper().extractGameInfo(gamePage!);

    gameInfoModel.postId = gamePageUri.pathSegments[1].split(".").last;
    gameInfoModel.downloadUrl = realDownloadLink;
    gameInfoModel.lastTimeUpdated = DateTime.now();
    gameInfoModel.isdownloaded = false;

    log(gameInfoModel.toString());

    LocalStorage().addGameToLibrary(gameInfoModel);

    // downloadProcess = await ProcessHelper().downloadFile(url: realDownloadLink!);
    // downloadProcess?.stdout.listen(log);
    // downloadProcess?.stderr.listen(log);
  }

  Future<void> startGameDownload(GameInfoModel gameInfoModel) async {
    var downloadProcess = await DownloadManager().startDownload(
      gameInfoModel.downloadUrl,
      fileName: DownloadManager.getFilenNameFromGameInfo(gameInfoModel),
    );

    downloadProcess?.stdout.listen(log);
    downloadProcess?.stderr.listen(log);

    var result = await downloadProcess?.waitExitCode;

    log(result.toString());

    if (result == 0) {
      var unzipProcess = await ProcessHelper().unzipFile(
        sourceFileName: DownloadManager.getFilenNameFromGameInfo(
          gameInfoModel,
        ),
      );

      unzipProcess?.stdout.listen(log);
      unzipProcess?.stderr.listen(log);

      var result = await unzipProcess.waitExitCode;

      log(result.toString());

      gameInfoModel.isdownloaded = true;
      LocalStorage().updateGameInfoModel(gameInfoModel);
    }
  }
}
