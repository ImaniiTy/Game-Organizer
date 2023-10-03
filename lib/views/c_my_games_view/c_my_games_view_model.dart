import '/components/c_game_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'c_my_games_view_widget.dart' show CMyGamesViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CMyGamesViewModel extends FlutterFlowModel<CMyGamesViewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for CGameCard component.
  late CGameCardModel cGameCardModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    cGameCardModel = createModel(context, () => CGameCardModel());
  }

  void dispose() {
    cGameCardModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
