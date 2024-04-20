import 'package:game_organizer/models/gameInfo.model.dart';

import 'processHelper.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();

  factory DownloadManager() {
    return _instance;
  }

  DownloadManager._internal();

  Map<String, DownloadProcess> downloadsList = {};

  Future<DownloadProcess?> startDownload(
    String? downloadUrl, {
    String? fileName,
  }) async {
    if (downloadUrl == null) return null;

    if (!downloadsList.containsKey(downloadUrl)) {
      downloadsList[downloadUrl] = await ProcessHelper().downloadFile(
        url: downloadUrl,
        fileName: fileName,
      )
        ..onFinished = () {
          removeFileFromList(downloadUrl);
        };
    }

    return downloadsList[downloadUrl];
  }

  Future<void> stopDownload(String downloadUrl) async {
    downloadsList[downloadUrl]?.source.kill();
    removeFileFromList(downloadUrl);
  }

  void removeFileFromList(String downloadUrl) {
    downloadsList.remove(downloadUrl);
  }

  bool isFileDownloading(String? downloadUrl) {
    return downloadsList.containsKey(downloadUrl);
  }

  DownloadProcess? getDownloadProcess(String? downloadUrl) {
    return downloadsList[downloadUrl];
  }

  static String getFilenNameFromGameInfo(GameInfoModel gameInfoModel, {bool withVersion = false}) {
    return "${gameInfoModel.title}-${gameInfoModel.postId}${withVersion ? "-${gameInfoModel.version!}" : ""}.zip"
        .replaceAll(RegExp(r' |\:'), "");
  }
}
