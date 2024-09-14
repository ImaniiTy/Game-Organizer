import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:game_organizer/services/localStorage.dart';
import 'package:game_organizer/services/processHelper.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'c_ssttings_view_widget.dart' show CSsttingsViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CSsttingsViewModel extends FlutterFlowModel<CSsttingsViewWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController3;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
    textController3?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  Future<void> saveFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    try {
      saveOnLocalStorage(Collections.cookies.name, json.decode(clipboardData?.text ?? "{}"));
    } catch (e) {
      log("Failed to decode ${clipboardData?.text}");
    }
  }

  Future<void> saveOnLocalStorage(String key, String value) async {
    await LocalStorage().setItem(key, value);
  }

  Future<void> cleanTempFolder() async {
    await ProcessHelper().deleteFolder(ProcessHelper.formatPath(ProcessHelper().tempFolder));
  }
}
