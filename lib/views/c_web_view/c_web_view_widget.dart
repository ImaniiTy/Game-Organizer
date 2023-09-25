import 'package:game_organizer/services/localStorage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_web_view_model.dart';
export 'c_web_view_model.dart';

class CWebViewWidget extends StatefulWidget {
  const CWebViewWidget({Key? key}) : super(key: key);

  @override
  _CWebViewWidgetState createState() => _CWebViewWidgetState();
}

class _CWebViewWidgetState extends State<CWebViewWidget> {
  late CWebViewModel _model;
  late WinWebViewController? _webviewController;
  late WindowsPlatformWebViewCookieManager _webViewCookieManager =
      WindowsPlatformWebViewCookieManager(PlatformWebViewCookieManagerCreationParams());

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CWebViewModel());
    _webviewController = WinWebViewController("/userDataTemp");
    _webviewController!.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webviewController!.setNavigationDelegate(WinNavigationDelegate(
      onNavigationRequest: (request) {
        return NavigationDecision.navigate;
      },
      onPageStarted: (url) async {
        print("onPageStarted: $url");
        var cookies = await _webviewController!.runJavaScriptReturningResult('document.cookie');
        if (!cookies.toString().contains("xf_session")) {
          var userSession = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");
          await _webviewController!
              .runJavaScriptReturningResult('document.cookie = "xf_session=${userSession["value"]};" + document.cookie');
          _webviewController!.reload();
        }
      },
      onPageFinished: (url) {
        // _webviewController!
        //     .runJavaScriptReturningResult('document.cookie = "xf_session=3N8gaDLNywymFfDOHTNZZsV_k8tbz3h0;" + document.cookie')
        //     .then((value) {
        //   // _webviewController!.reload();
        // });
      },
      onWebResourceError: (error) => print("onWebResourceError: ${error.description}"),
    ));
    _webviewController!.loadRequest(Uri.parse("https://f95zone.to/sam/latest_alpha/"));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _webviewController?.dispose();
    _webviewController = null;
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
        controller: _webviewController!,
      ),
    );
  }
}
