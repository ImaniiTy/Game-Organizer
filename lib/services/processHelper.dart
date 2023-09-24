import 'dart:convert';
import 'dart:io';

import 'package:game_organizer/services/localStorage.dart';

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

  Future<Process> runCommand({String dest = "", String userAgent = "", String args = "", String program = "aria2c"}) async {
    var argsList = args.split(" ");
    argsList[argsList.indexWhere((element) => element == "%{dest}")] = dest;
    argsList[argsList.indexWhere((element) => element == "%{userAgent}")] = userAgent;
    print("Run with command: $program ${argsList.join(' ')}");
    return await Process.start(program, argsList);
  }

  Future<DownloadProcess> downloadFile({required String url, required String fileName}) async {
    Uri uri = Uri.parse(url);
    String referer = getReferer(uri);

    var sourceProcess = await runCommand(args: "-d ${LocalStorage().getItem("tempFolder") ?? KTEMP_FOLDER} ${uri.toString()}");

    return DownloadProcess(source: sourceProcess);
  }

  String getReferer(Uri uri) {
    List<String> origin = uri.host.split(".").reversed.toList();
    return "https://${origin[1]}.${origin[0]}";
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

  Stream<String> get stdout => source.stdout.transform(utf8.decoder);
  Stream<String> get stderr => source.stderr.transform(utf8.decoder);

  DownloadProcess({
    required this.source,
  });
}