import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_organizer/services/navigation/navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';

import 'package:game_organizer/services/localStorage.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'c_web_view_model.dart';

export 'c_web_view_model.dart';

class CWebViewWidget extends StatefulWidget {
  const CWebViewWidget({
    Key? key,
    this.params,
  }) : super(key: key);

  final Map<String, String>? params;

  @override
  _CWebViewWidgetState createState() => _CWebViewWidgetState();
}

class _CWebViewWidgetState extends State<CWebViewWidget> {
  late CWebViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CWebViewModel());
    webviewController = WinWebViewController("/userDataTemp");
    webviewController!.setJavaScriptMode(JavaScriptMode.unrestricted);
    webviewController!.setNavigationDelegate(WinNavigationDelegate(
      onNavigationRequest: (request) async {
        return await _model.onNavigationRequest(webviewController!, request);
      },
      onPageStarted: (url) async {
        // print("onPageStarted: $url");
        // var cookies = await webviewController!.runJavaScriptReturningResult('document.cookie');
        // if (!cookies.toString().contains("xf_session")) {
        //   var userSession = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");
        //   await webviewController!
        //       .runJavaScriptReturningResult('document.cookie = "xf_session=${userSession["value"]};" + document.cookie');
        //   webviewController!.reload();
        // }
      },
      onPageFinished: (url) {
        // _webviewController!
        //     .runJavaScriptReturningResult('document.cookie = "xf_session=3N8gaDLNywymFfDOHTNZZsV_k8tbz3h0;" + document.cookie')
        //     .then((value) {
        //   // _webviewController!.reload();
        // });
      },
      onWebResourceError: (error) => print("onWebResourceError: ${error.description}"),
      onHistoryChanged: () async {
        String? currentUrl = await webviewController?.currentUrl();
        if (currentUrl == "about:blank") {
          Navigation().goBack();
        }
      },
    ));
    // var sessionCookie = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");

    if (LocalStorage().getItem("cookies") != null) {
      for (var cookie in LocalStorage().getItem("cookies")) {
        webviewController!.addCookie(cookie["name"], cookie["value"], cookie["domain"], cookie["path"]);
      }
    }

    webviewController!.loadRequest(Uri.parse(widget.params?["initialUrl"] ?? "https://f95zone.to/sam/latest_alpha/"));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    webviewController?.dispose();
    webviewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: WinWebViewWidget(
        controller: webviewController!,
      ),
    );
  }
}
