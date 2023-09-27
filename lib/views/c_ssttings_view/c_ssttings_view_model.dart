import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:game_organizer/services/localStorage.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CSsttingsViewModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  Future<void> saveFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    try {
      LocalStorage().setItem(Collections.cookies.name, json.decode(clipboardData?.text ?? "{}"));
    } catch (e) {
      log("Failed to decode ${clipboardData?.text}");
    }
  }
}
