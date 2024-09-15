import "dart:developer";
import "dart:io";

import "package:game_organizer/models/gameInfo.model.dart";
import "package:game_organizer/services/downloadManager.dart";
import "package:game_organizer/services/processHelper.dart";

class UniversalCheat {
  Future<void> downloadLatestVersion() async {
    var process = await DownloadManager().startDownload(
      "https://api.0x52.dev/modversions/1211/download",
      fileName: "0x52.zip",
      folderPath: "tools/0x52",
    );

    process?.stdout.listen(log);

    await process?.waitExitCode;
  }

  Future<void> tryInstall(GameInfoModel gameInfoModel) async {
    var gameFileName = DownloadManager.getFilenNameFromGameInfo(gameInfoModel).split(".zip").first;
    String extractedFolderPath = ProcessHelper.formatPath("${ProcessHelper().gamesFolder}/${gameFileName}/extracted");

    var extractedDir = Directory(extractedFolderPath);
    if (extractedDir.existsSync()) {
      var renpayGameDir = Directory("${extractedDir.listSync()[0].path}/game");
      print(renpayGameDir.path);

      var zipFile = File("tools/0x52/0x52.zip");

      if (!zipFile.existsSync()) {
        await downloadLatestVersion();
      }

      var process = await DownloadManager().startUnzip(sourceFilePath: "tools/0x52/0x52.zip", destFilePath: renpayGameDir.path);

      await process?.waitExitCode;
    }
  }
}
