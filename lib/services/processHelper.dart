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

  Future<Process> runCommand({
    String dest = "",
    String userAgent = "",
    String args = "",
    String program = "aria2c.exe",
    bool runInShell = false,
    bool detached = false,
  }) async {
    var argsList = args.split(" ");
    // argsList[argsList.indexWhere((element) => element == "%{dest}")] = dest;
    // argsList[argsList.indexWhere((element) => element == "%{userAgent}")] = userAgent;
    print("Run with command: $program ${argsList.join(' ')}");
    return await Process.start(
      program,
      argsList,
      runInShell: runInShell,
      mode: detached ? ProcessStartMode.detached : ProcessStartMode.normal,
    );
  }

  Future<DownloadProcess> downloadFile({required String url, String? fileName, String? folderPath}) async {
    Uri uri = Uri.parse(url);
    String? referer = getReferer(uri);
    String cookies = "cookie:${SessionManager().getSessionAsString()};${SessionManager().downloadCookies}";

    var sourceProcess = await runCommand(
      args:
          '-d ${folderPath ?? LocalStorage().getItem("tempFolder") ?? KTEMP_FOLDER} -o $fileName --header=$cookies -x 10 -s 10 -m 20 ${uri.toString()}',
    );

    return DownloadProcess(
      source: sourceProcess,
      statusParser: (String stdout) {
        if (stdout.contains("ETA")) {
          return DownloadStatus.fromString(stdout);
        }
      },
    );
  }

  Future<DownloadProcess> unzipFile({required String sourceFilePath, required String destFilePath}) async {
    var sourceProcess = await runCommand(
      program: "7z.exe",
      args: 'x ${sourceFilePath} -o${destFilePath} -y',
    );

    return DownloadProcess(
      source: sourceProcess,
      statusParser: (String stdout) {
        // var match = RegExp(r"([0-9]+)%").firstMatch(stdout);

        // return match?[0] != null ? int.parse(match![0]!.split("%")[0]) : null;
        return !stdout.contains("Everything is Ok") ? "Extracting..." : null;
      },
    );
  }

  Future<void> runExecutable(String path) async {
    await runCommand(program: path, detached: true);
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
  Function? statusParser;

  late Future<int> waitExitCode;

  Future<int> get finishedFuture => waitExitCode;

  late Stream<String> stdout = source.stdout.transform(utf8.decoder).asBroadcastStream();
  late Stream<String> stderr = source.stderr.transform(utf8.decoder).asBroadcastStream();

  Stream<dynamic> get statusStream => statusParser != null ? stdout.map((event) => statusParser?.call(event)) : stdout;

  DownloadProcess({
    required this.source,
    this.statusParser,
  }) {
    this.waitExitCode = this.source.exitCode;
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
