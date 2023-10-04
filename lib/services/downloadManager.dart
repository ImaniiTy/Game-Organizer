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
      );
    }

    return downloadsList[downloadUrl];
  }

  Future<void> stop(String downloadUrl) async {
    downloadsList[downloadUrl]?.source.kill();
  }

  static String getFilenNameFromGameInfo(GameInfoModel gameInfoModel) {
    return "${gameInfoModel.title}-${gameInfoModel.postId}-${gameInfoModel.version}.zip".replaceAll(" ", "");
  }
}
