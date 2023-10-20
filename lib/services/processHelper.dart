import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:game_organizer/services/localStorage.dart';
import 'package:game_organizer/services/sessionManager.dart';

const String USER_AGENT =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 OPR/91.0.4516.106";

const String KTEMP_FOLDER = "./temp";
const String KGAMES_FOLDER = "./games";

class ProcessHelper {
  static final ProcessHelper _instance = ProcessHelper._internal();

  factory ProcessHelper() {
    return _instance;
  }

  ProcessHelper._internal();

  String get gamesFolder => LocalStorage().getItem("gamesFolder") ?? KGAMES_FOLDER;
  String get tempFolder => LocalStorage().getItem("tempFolder") ?? KTEMP_FOLDER;

  Future<Process> runCommand({String dest = "", String userAgent = "", String args = "", String program = "aria2c.exe"}) async {
    var argsList = args.split(" ");
    // argsList[argsList.indexWhere((element) => element == "%{dest}")] = dest;
    // argsList[argsList.indexWhere((element) => element == "%{userAgent}")] = userAgent;
    print("Run with command: $program ${argsList.join(' ')}");
    return await Process.start(program, argsList);
  }

  Future<DownloadProcess> downloadFile({required String url, String? fileName}) async {
    Uri uri = Uri.parse(url);
    String? referer = getReferer(uri);
    String cookies = "cookie:${SessionManager().getSessionAsString()}";

    var sourceProcess = await runCommand(
      args:
          '-d ${LocalStorage().getItem("tempFolder") ?? KTEMP_FOLDER} -o $fileName --header=$cookies -x 10 -s 10 -m 20 ${uri.toString()}',
    );

    return DownloadProcess(source: sourceProcess);
  }

  Future<DownloadProcess> unzipFile({required String sourceFileName, required String destFileName}) async {
    try {
      await deleteFolder(formatPath("${gamesFolder}/${destFileName.split(".zip").first}/temp"));
    } catch (e) {}

    var sourceProcess = await runCommand(
      program: "7z.exe",
      args: 'x ${tempFolder}/${sourceFileName} -o${gamesFolder}/${destFileName.split(".zip").first}/temp -y',
    );

    return DownloadProcess(
      source: sourceProcess,
      onFinished: () {
        deleteFile(formatPath("${tempFolder}/${sourceFileName}"));
      },
    );
  }

  Future<void> runExecutable(String path) async {
    await runCommand(program: path);
  }

  Future<void> deleteFile(String path) async {
    File(formatPath(path)).deleteSync();
  }

  Future<void> deleteFolder(String path) async {
    Directory(formatPath(path)).deleteSync(recursive: true);
  }

  String? getReferer(Uri uri) {
    try {
      List<String> origin = uri.host.split(".").reversed.toList();
      return "https://${origin[1]}.${origin[0]}";
    } catch (e) {
      log(e.toString());
    }
  }

  static String formatPath(String path) {
    return path.replaceAll("/", "\\");
  }

  // static Future<DownloadProcess> downloadM3u8({required String url, required String fileName}) async {
  //   // -i "%url%" -c copy "%name%.mp4"
  //   Uri uri = Uri.parse(url);
  //   List<String> origin = uri.host.split(".").reversed.toList();
  //   String referer = "https://${origin[1]}.${origin[0]}";
  //   var sourceProcess = await runCommand(
  //     dest: "${Config.data["destFolder"]}\\$fileName\.mp4",
  //     userAgent: USER_AGENT,
  //     // // ffmpeg
  //     // downloader: "ffmpeg",
  //     // args: '-headers referer:$referer -user_agent $USER_AGENT -i $url -c copy $dest',
  //     // yt-dlp
  //     downloader: "yt-dlp",
  //     args: '-o %{dest} --referer $referer --user-agent %{userAgent} --cookies cookies.txt $url',
  //   );

  //   return DownloadProcess(source: sourceProcess);
  // }
}

class DownloadProcess {
  Process source;
  Function? onFinished;

  late Future<int> waitExitCode;

  late Stream<String> stdout = source.stdout.transform(utf8.decoder).asBroadcastStream();
  late Stream<String> stderr = source.stderr.transform(utf8.decoder).asBroadcastStream();

  DownloadProcess({
    required this.source,
    this.onFinished,
  }) {
    this.waitExitCode = this.source.exitCode;
    this.source.exitCode.then((value) {
      if (value == 0) this.onFinished?.call();
    });
  }
}

class DownloadStatus {
  String currentSize;
  String totalSize;
  String currentPercent;
  String downloadSpeed;
  String eta;

  static String _regexp = r"\[.*#(\S+) (\S+)\/(\S+)\((\S+)%\).*DL:(\S+) ETA:(\S+).*\]";

  DownloadStatus({
    required this.currentSize,
    required this.totalSize,
    required this.currentPercent,
    required this.downloadSpeed,
    required this.eta,
  });

  factory DownloadStatus.fromString(String string) {
    var match = RegExp(_regexp).firstMatch(string);

    return DownloadStatus(
      currentSize: match!.group(2) ?? "",
      totalSize: match!.group(3) ?? "",
      currentPercent: match!.group(4) ?? "",
      downloadSpeed: match!.group(5) ?? "",
      eta: match!.group(6) ?? "",
    );
  }
}
