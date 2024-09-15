import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:rxdart/rxdart.dart';

import 'processHelper.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();

  factory DownloadManager() {
    return _instance;
  }

  DownloadManager._internal();

  Map<String, DownloadProcess> downloadsList = {};
  BehaviorSubject<Map<String, DownloadProcess>> downloadsStream = BehaviorSubject.seeded({});

  Future<DownloadProcess?> startDownload(
    String? downloadUrl, {
    String? fileName,
    String? folderPath,
  }) async {
    if (downloadUrl == null) return null;

    if (!downloadsStream.value.containsKey(downloadUrl)) {
      Map<String, DownloadProcess> newMap = Map.from(downloadsStream.value);
      newMap[downloadUrl] = await ProcessHelper().downloadFile(
        url: downloadUrl,
        fileName: fileName,
        folderPath: folderPath,
      )
        ..finishedFuture.then((value) {
          removeFileFromStream(downloadUrl);
        });
      downloadsStream.add(newMap);
    }

    return downloadsStream.value[downloadUrl];

    // if (!downloadsList.containsKey(downloadUrl)) {
    //   downloadsList[downloadUrl] = await ProcessHelper().downloadFile(
    //     url: downloadUrl,
    //     fileName: fileName,
    //   )
    //     ..onFinished = () {
    //       removeFileFromList(downloadUrl);
    //     };
    // }

    // return downloadsList[downloadUrl];
  }

  Future<DownloadProcess?> startUnzip({required String sourceFilePath, required String destFilePath}) async {
    if (!downloadsStream.value.containsKey(sourceFilePath)) {
      Map<String, DownloadProcess> newMap = Map.from(downloadsStream.value);
      newMap[sourceFilePath] = await ProcessHelper().unzipFile(sourceFilePath: sourceFilePath, destFilePath: destFilePath)
        ..finishedFuture.then((value) {
          removeFileFromStream(sourceFilePath);
        });
      downloadsStream.add(newMap);
    }

    return downloadsStream.value[sourceFilePath];
  }

  Future<void> stopDownload(String downloadUrl) async {
    downloadsList[downloadUrl]?.source.kill();
    removeFileFromList(downloadUrl);
  }

  void removeFileFromList(String downloadUrl) {
    downloadsList.remove(downloadUrl);
  }

  void removeFileFromStream(String downloadUrl) {
    Map<String, DownloadProcess> newMap = Map.from(downloadsStream.value);
    newMap.remove(downloadUrl);

    downloadsStream.add(newMap);
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
