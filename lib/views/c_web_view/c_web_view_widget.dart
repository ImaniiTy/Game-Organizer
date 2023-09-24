import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CWebViewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

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
      child: FlutterFlowWebView(
        content: 'https://f95zone.to/',
        bypass: false,
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: MediaQuery.sizeOf(context).height * 1.0,
        verticalScroll: false,
        horizontalScroll: false,
      ),
    );
  }
}
