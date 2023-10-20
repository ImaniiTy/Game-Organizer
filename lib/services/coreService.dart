import 'dart:developer';
import 'dart:io';

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

    startGameDownload(gameInfoModel);
  }

  Future<void> startGameDownload(GameInfoModel gameInfoModel, {Function? onDownloadStarted}) async {
    var downloadProcess = await DownloadManager().startDownload(
      gameInfoModel.downloadUrl,
      fileName: DownloadManager.getFilenNameFromGameInfo(gameInfoModel, withVersion: true),
    );

    onDownloadStarted?.call();

    downloadProcess?.stdout.listen(log);
    downloadProcess?.stderr.listen(log);

    var result = await downloadProcess?.waitExitCode;

    log(result.toString());

    if (result == 0) {
      var gameFolder = DownloadManager.getFilenNameFromGameInfo(gameInfoModel).split(".zip").first;
      var gameFilesPath = "${ProcessHelper().gamesFolder}/$gameFolder";

      var unzipProcess = await ProcessHelper().unzipFile(
        sourceFileName: DownloadManager.getFilenNameFromGameInfo(
          gameInfoModel,
          withVersion: true,
        ),
        destFileName: DownloadManager.getFilenNameFromGameInfo(
          gameInfoModel,
          withVersion: false,
        ),
      );

      unzipProcess?.stdout.listen(log);
      unzipProcess?.stderr.listen(log);

      var result = await unzipProcess.waitExitCode;

      log(result.toString());

      if (result == 0) {
        try {
          await ProcessHelper().deleteFolder("$gameFilesPath/old");
        } catch (e) {}

        try {
          var lastVersionFolder = Directory(ProcessHelper.formatPath("$gameFilesPath/extracted"));
          if (lastVersionFolder.existsSync()) {
            lastVersionFolder.renameSync(ProcessHelper.formatPath("$gameFilesPath/old"));
          }
          Directory(ProcessHelper.formatPath("$gameFilesPath/temp"))
              .renameSync(ProcessHelper.formatPath("$gameFilesPath/extracted"));
        } catch (e) {}

        gameInfoModel.isdownloaded = true;
        gameInfoModel.lastTimeUpdated = DateTime.now();
        LocalStorage().updateGameInfoModel(gameInfoModel);
      }
    }
  }

  Future<bool?> checkForUpdates(GameInfoModel gameInfoModel) async {
    var gamePage = await Scrapper().getPageParser("https://f95zone.to/threads/${gameInfoModel.postId}");
    var updatedGameInfoModel = Scrapper().extractGameInfo(gamePage!);

    return updatedGameInfoModel.version != gameInfoModel.version;
  }

  void runGame(GameInfoModel gameInfoModel) {
    gameInfoModel.lastTimePlayed = DateTime.now();
    LocalStorage().updateGameInfoModel(gameInfoModel);
    ProcessHelper().runExecutable(gameInfoModel.executablePath!);
  }
}
