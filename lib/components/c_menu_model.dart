import 'dart:developer';

import 'package:game_organizer/services/processHelper.dart';
import 'package:game_organizer/services/scrapper.dart';
import 'package:game_organizer/views/c_web_view/c_web_view_model.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'c_menu_widget.dart' show CMenuWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

DownloadProcess? downloadProcess;

class CMenuModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  Future<void> fetchGameInfo() async {
    downloadProcess?.source.kill();
    String? currentPage = await webviewController?.currentUrl();
    if (currentPage == null) return;

    var page = await Scrapper().getPageParser(currentPage);
    var downloadLinks = Scrapper().getSupportedHostsFrommPage(page!);

    // TEST
    var realDownloadLink = await Scrapper().getRealDownloadUrl(downloadLinks[1]!);
    downloadProcess = await ProcessHelper().downloadFile(url: realDownloadLink!);
    downloadProcess?.stdout.listen(log);
    downloadProcess?.stderr.listen(log);
    return;
  }
}
