import 'package:game_organizer/services/coreService.dart';
import 'package:game_organizer/services/navigation/navigation.dart';
import 'package:game_organizer/services/scrapper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'c_web_view_widget.dart' show CWebViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

WinWebViewController? webviewController;

class CWebViewModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  Future<NavigationDecision> onNavigationRequest(WinWebViewController webviewController, NavigationRequest request) async {
    var currentUrl = await webviewController.currentUrl() ?? "";
    bool isADownloadUrl = Scrapper.supportedHosts.any((element) => request.url.contains(element));
    if (currentUrl.contains("f95zone.to/threads") && isADownloadUrl) {
      CoreService().addGameAndStartDownload(currentUrl, request.url);
      // Navigation().goTo("/MyGames");
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }
}
