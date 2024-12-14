import 'package:game_organizer/services/coreService.dart';
import 'package:game_organizer/services/navigation/navigation.dart';
import 'package:game_organizer/services/scrapper.dart';
import 'package:game_organizer/services/sessionManager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'c_web_view_widget.dart' show CWebViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum FetchStatus { none, done, running }

WinWebViewController? webviewController;
BehaviorSubject<FetchStatus> gameInfoFetchFuture = BehaviorSubject.seeded(FetchStatus.none);

class CWebViewModel extends FlutterFlowModel {
  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  String? lastThreadUrl;

  // Future<NavigationDecision> onNavigationRequest(WinWebViewController webviewController, NavigationRequest request) async {
  //   var currentUrl = await webviewController.currentUrl() ?? "";
  //   bool isADownloadUrl = Scrapper.supportedHosts.any((element) => request.url.contains(element));
  //   print("request: ${request.url}");
  //   if (currentUrl.contains("f95zone.to/threads") && isADownloadUrl) {
  //     gameInfoFetchFuture.add(FetchStatus.running);
  //     CoreService().addGameAndStartDownload(currentUrl, request.url).then((_) {
  //       gameInfoFetchFuture.add(FetchStatus.done);
  //       Future.delayed(Duration(seconds: 2)).then((_) => gameInfoFetchFuture.add(FetchStatus.none));
  //     });
  //     // Navigation().goTo("/MyGames");

  //     return NavigationDecision.prevent;
  //   } else {
  //     return NavigationDecision.navigate;
  //   }
  // }
  Future<NavigationDecision> onNavigationRequest(WinWebViewController webviewController, NavigationRequest request) async {
    var currentUrl = await webviewController.currentUrl() ?? "";
    if (currentUrl.contains("f95zone.to/threads")) lastThreadUrl = currentUrl;

    return NavigationDecision.navigate;
    bool isADownloadUrl = Scrapper.supportedHosts.any((element) => request.url.contains(element));
    print("request: ${request.url}");
    if (currentUrl.contains("f95zone.to/threads") && isADownloadUrl) {
      gameInfoFetchFuture.add(FetchStatus.running);
      CoreService().addGameAndStartDownload(currentUrl, request.url).then((_) {
        gameInfoFetchFuture.add(FetchStatus.done);
        Future.delayed(Duration(seconds: 2)).then((_) => gameInfoFetchFuture.add(FetchStatus.none));
      });
      // Navigation().goTo("/MyGames");

      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  Future<void> onDownloadStarted(WinWebViewController webviewController, String url, String downloadCookies) async {
    print("OnDownloadStarted:${url}");
    SessionManager().setDownloadCookies(downloadCookies);
    if (lastThreadUrl != null) {
      gameInfoFetchFuture.add(FetchStatus.running);
      CoreService().addGameAndStartDownload(lastThreadUrl!, url).then((_) {
        gameInfoFetchFuture.add(FetchStatus.done);
        Future.delayed(Duration(seconds: 2)).then((_) => gameInfoFetchFuture.add(FetchStatus.none));
      });

      webviewController.loadRequest(Uri.parse(lastThreadUrl!));
    }
  }
}
