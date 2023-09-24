import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/c_ssttings_view/c_ssttings_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for CSsttingsView component.
  late CSsttingsViewModel cSsttingsViewModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    cSsttingsViewModel = createModel(context, () => CSsttingsViewModel());
  }

  void dispose() {
    unfocusNode.dispose();
    cSsttingsViewModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
