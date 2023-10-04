import 'package:game_organizer/models/gameInfo.model.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_game_card_model.dart';
export 'c_game_card_model.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

class CGameCardWidget extends StatefulWidget {
  const CGameCardWidget({Key? key, required this.gameInfoModel}) : super(key: key);

  final GameInfoModel gameInfoModel;

  @override
  _CGameCardWidgetState createState() => _CGameCardWidgetState();
}

class _CGameCardWidgetState extends State<CGameCardWidget> {
  late CGameCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CGameCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Color getEngineColor(String engine) {
    switch (engine) {
      case "Unity":
        return Color(0xFFFE5901);
      case "RPGM":
        return Color(0xFF2196f3);
      case "Ren'Py":
        return Color(0xFFB069E8);
      case "Others":
        return Color(0xFF8bc34a);
      default:
        return FlutterFlowTheme.of(context).secondaryBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).alternate,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FastCachedImage(
                    url: widget.gameInfoModel.thumbnailUrl ?? "",
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: Color(0x0014181B),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.00, -1.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 0.0, 0.0),
                          child: Text(
                            widget.gameInfoModel.title ?? "",
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(1.00, 0.16),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: Container(
                height: 27.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 2.0),
                  child: Text(
                    widget.gameInfoModel.version ?? "",
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-1.00, -1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
              child: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  color: getEngineColor(widget.gameInfoModel.engine ?? ""),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 2.0),
                  child: Text(
                    widget.gameInfoModel.engine ?? "",
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(1.00, 1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).secondary,
                borderRadius: 8.0,
                borderWidth: 0.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).secondary,
                icon: Icon(
                  Icons.play_arrow,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                showLoadingIndicator: true,
                onPressed: () {},
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-1.00, 1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 12.0, 4.0),
                    child: FaIcon(
                      FontAwesomeIcons.folderOpen,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 12.0, 4.0),
                    child: FaIcon(
                      FontAwesomeIcons.globe,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(1.00, -1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
              child: FaIcon(
                FontAwesomeIcons.trashAlt,
                color: FlutterFlowTheme.of(context).error,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
