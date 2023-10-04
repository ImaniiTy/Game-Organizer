import 'dart:developer';

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
    gameInfoModel.downloadUrl = downloadUrl;
    gameInfoModel.lastTimeUpdated = DateTime.now();
    gameInfoModel.isdownloaded = false;

    log(gameInfoModel.toString());

    LocalStorage().addGameToLibrary(gameInfoModel);

    // downloadProcess = await ProcessHelper().downloadFile(url: realDownloadLink!);
    // downloadProcess?.stdout.listen(log);
    // downloadProcess?.stderr.listen(log);
  }
}
