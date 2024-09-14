import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/coreService.dart';
import 'package:game_organizer/services/downloadManager.dart';
import 'package:game_organizer/services/localStorage.dart';
import 'package:game_organizer/services/navigation/navigation.dart';
import 'package:game_organizer/services/processHelper.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_game_card_model.dart';
export 'c_game_card_model.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

class CGameCardWidget extends StatefulWidget {
  const CGameCardWidget({Key? key, required this.gameInfoModel}) : super(key: key);

  final GameInfoModel gameInfoModel;

  @override
  _CGameCardWidgetState createState() => _CGameCardWidgetState();
}

class _CGameCardWidgetState extends State<CGameCardWidget> {
  late CGameCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CGameCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Color getEngineColor(String engine) {
    switch (engine) {
      case "Unity":
        return Color(0xFFFE5901);
      case "RPGM":
        return Color(0xFF2196f3);
      case "Ren'Py":
        return Color(0xFFB069E8);
      case "Others":
        return Color(0xFF8bc34a);
      default:
        return FlutterFlowTheme.of(context).secondaryBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).alternate,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigation().goTo("/WebView", params: {"initialUrl": "https://f95zone.to/threads/${widget.gameInfoModel.postId}"});
        },
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FastCachedImage(
                      key: ValueKey(widget.gameInfoModel.thumbnailUrl),
                      url: widget.gameInfoModel.thumbnailUrl ?? "",
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: BoxDecoration(
                      color: Color(0x0014181B),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.00, -1.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 0.0, 0.0),
                            child: Text(
                              widget.gameInfoModel.title ?? "",
                              style: FlutterFlowTheme.of(context).titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(1.00, 0.16),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                child: Container(
                  height: 27.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 2.0),
                    child: Text(
                      widget.gameInfoModel.version ?? "",
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.00, -1.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
                child: Container(
                  height: 27.0,
                  decoration: BoxDecoration(
                    color: getEngineColor(widget.gameInfoModel.engine ?? ""),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 2.0),
                    child: Text(
                      widget.gameInfoModel.engine ?? "",
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1.00, 1.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
                child: FlutterFlowIconButton(
                  borderColor:
                      widget.gameInfoModel.isdownloaded ?? false ? FlutterFlowTheme.of(context).secondary : Colors.blueAccent,
                  borderRadius: 8.0,
                  borderWidth: 0.0,
                  buttonSize: 40.0,
                  fillColor:
                      widget.gameInfoModel.isdownloaded ?? false ? FlutterFlowTheme.of(context).secondary : Colors.blueAccent,
                  icon: Icon(
                    () {
                      if (DownloadManager().isFileDownloading(widget.gameInfoModel.downloadUrl)) return Icons.pause;

                      return !widget.gameInfoModel.isdownloaded! || widget.gameInfoModel.isdownloaded == null
                          ? Icons.download
                          : Icons.play_arrow;
                    }(),
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  showLoadingIndicator: true,
                  onPressed: () async {
                    if (widget.gameInfoModel.isdownloaded ?? false) {
                      if (widget.gameInfoModel.executablePath != null) {
                        CoreService().runGame(widget.gameInfoModel);
                      } else {
                        var gameFileName = DownloadManager.getFilenNameFromGameInfo(widget.gameInfoModel).split(".zip").first;
                        String gameFolderPath =
                            ProcessHelper.formatPath("${ProcessHelper().gamesFolder}/${gameFileName}/extracted");
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          dialogTitle: "Select Executable",
                          allowMultiple: false,
                          allowedExtensions: ["exe"],
                          initialDirectory: gameFolderPath,
                        );
                        if (result != null) {
                          widget.gameInfoModel.executablePath = result.paths[0];
                          CoreService().runGame(widget.gameInfoModel);
                        }
                      }
                    } else if (DownloadManager().isFileDownloading(widget.gameInfoModel.downloadUrl!)) {
                      DownloadManager().stopDownload(widget.gameInfoModel.downloadUrl!);
                    } else {
                      CoreService().startGameDownload(widget.gameInfoModel, onDownloadStarted: () => setState(() {}));
                    }

                    setState(() {});
                  },
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.00, 1.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        var gameFileName = DownloadManager.getFilenNameFromGameInfo(widget.gameInfoModel).split(".zip").first;
                        String gameFolderPath =
                            ProcessHelper.formatPath("${ProcessHelper().gamesFolder}/${gameFileName}/extracted");

                        // Uri _url = Uri.parse('file:${Directory.current.path}/${gameFolderPath}');
                        // launchUrl(_url, mode: LaunchMode.externalApplication);
                        String path = Uri.parse('${Directory.current.path}/${gameFolderPath}').toString();
                        print(path);
                        Process.run(
                          "start",
                          [path],
                          // workingDirectory: path,
                          runInShell: true,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 12.0, 4.0),
                        child: FaIcon(
                          FontAwesomeIcons.folderOpen,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 22.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse("https://f95zone.to/threads/${widget.gameInfoModel.postId}"));
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 12.0, 4.0),
                        child: FaIcon(
                          FontAwesomeIcons.globe,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 22.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool? hasUpdates = await CoreService().checkForUpdates(widget.gameInfoModel);
                        if (!hasUpdates!) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Center(
                              child: Text(
                                "No Updates",
                                style: FlutterFlowTheme.of(context).titleMedium.copyWith(color: Colors.black),
                              ),
                            ),
                            backgroundColor: Colors.greenAccent,
                            duration: Duration(seconds: 3),
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                          ));
                        } else {
                          Navigation().goTo("/WebView",
                              params: {"initialUrl": "https://f95zone.to/threads/${widget.gameInfoModel.postId}"});
                        }
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 12.0, 4.0),
                        child: FaIcon(
                          FontAwesomeIcons.arrowsRotate,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 22.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      () {
                        try {
                          String formatedDate = DateFormat.yMd().add_Hm().format(widget.gameInfoModel.lastTimePlayed!);
                          return "Played at:\n$formatedDate";
                        } catch (e) {
                          return "Played at:\n";
                        }
                      }(),
                      style: FlutterFlowTheme.of(context).labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1.00, -1.00),
              child: Container(
                height: 64,
                width: 50,
                child: MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: FlutterFlowTheme.of(context).error),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                  child: Text('Confirm'),
                                  style:
                                      ButtonStyle(backgroundColor: MaterialStatePropertyAll(FlutterFlowTheme.of(context).error)),
                                  onPressed: () {
                                    LocalStorage().removeGameFromLibrary(widget.gameInfoModel);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    MenuItemButton(
                      child: Text("Add 0x52"),
                      onPressed: () {},
                    ),
                  ],
                  builder: (context, controller, child) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (DownloadManager().getDownloadProcess(widget.gameInfoModel.downloadUrl) != null)
              StreamBuilder<String>(
                  stream: DownloadManager().getDownloadProcess(widget.gameInfoModel.downloadUrl!)?.stdout,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) log(snapshot.data!);
                    if (!snapshot.hasData || !snapshot.data!.contains("ETA")) {
                      return Container();
                    }

                    DownloadStatus downloadStatus = DownloadStatus.fromString(snapshot.data!);
                    return Align(
                      alignment: AlignmentDirectional(-1.0, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green.shade900, Colors.black87],
                              stops: List.generate(2, (index) => double.parse(downloadStatus.currentPercent) / 100),
                              tileMode: TileMode.clamp,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text("${downloadStatus.downloadSpeed}s ETA:${downloadStatus.eta}"),
                          ),
                        ),
                      ),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
