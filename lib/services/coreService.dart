import 'dart:developer';

import 'package:game_organizer/services/processHelper.dart';
import 'package:game_organizer/services/scrapper.dart';

DownloadProcess? downloadProcess;

class CoreService {
  static final CoreService _instance = CoreService._internal();

  factory CoreService() {
    return _instance;
  }

  CoreService._internal();

  Future<void> addGameAndStartDownload(String gamePageUrl, String downloadUrl) async {
    downloadProcess?.source.kill();

    var gamePage = await Scrapper().getPageParser(gamePageUrl);
    var realDownloadLink = await Scrapper().getRealDownloadUrl(downloadUrl);

    var gameInfoModel = Scrapper().extractGameInfo(gamePage!);

    gameInfoModel.downloadUrl = downloadUrl;
    gameInfoModel.lastTimeUpdated = DateTime.now();

    log(gameInfoModel.toString());

    downloadProcess = await ProcessHelper().downloadFile(url: realDownloadLink!);
    downloadProcess?.stdout.listen(log);
    downloadProcess?.stderr.listen(log);
  }
}
