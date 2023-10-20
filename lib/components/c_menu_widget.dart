import 'package:game_organizer/services/navigation/navigation.dart';
import 'package:game_organizer/views/c_my_games_view/c_my_games_view_widget.dart';
import 'package:game_organizer/views/c_ssttings_view/c_ssttings_view_widget.dart';
import 'package:game_organizer/views/c_web_view/c_web_view_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_menu_model.dart';
export 'c_menu_model.dart';

class CMenuWidget extends StatefulWidget {
  const CMenuWidget({Key? key}) : super(key: key);

  @override
  _CMenuWidgetState createState() => _CMenuWidgetState();
}

class _CMenuWidgetState extends State<CMenuWidget> {
  late CMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CMenuModel());
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
        color: FlutterFlowTheme.of(context).accent4,
      ),
      child: StreamBuilder<NavigationContext>(
          stream: Navigation().navigationStream,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Color(0x00262D34),
                        border: Border.all(
                          color: Color(0x00FFFFFF),
                          width: 0.0,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: FaIcon(
                          FontAwesomeIcons.gamepad,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Color(0x15FFFFFF),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.00, 0.00),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            Navigation().goTo("/MyGames");
                          },
                          text: 'My Games',
                          icon: Icon(
                            Icons.home_sharp,
                            color: Color(0x2DCACACA),
                            size: 28.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                            color: Colors.transparent,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.00, 0.00),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            Navigation().goTo("/WebView");
                          },
                          text: 'Latest Games',
                          icon: Icon(
                            Icons.search_rounded,
                            color: Color(0x2DCACACA),
                            size: 28.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                            color: Colors.transparent,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.00, 0.00),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            Navigation().goTo("/Settings");
                          },
                          text: 'Settings',
                          icon: Icon(
                            Icons.settings,
                            color: Color(0x2DCACACA),
                            size: 28.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                            color: Colors.transparent,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    if (snapshot.data?.name == "/WebView")
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                          child: StreamBuilder(
                            stream: gameInfoFetchFuture,
                            initialData: FetchStatus.none,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data! == FetchStatus.running) {
                                return Row(
                                  children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Adding Game...")],
                                );
                              } else if (snapshot.data! == FetchStatus.done) {
                                return Icon(Icons.check, color: Colors.green);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                if (snapshot.data?.name == "/WebView")
                  Align(
                    alignment: AlignmentDirectional(1.00, -1.00),
                    child: FlutterFlowIconButton(
                      borderColor: Color(0x004B39EF),
                      borderRadius: 0.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      fillColor: Color(0x004B39EF),
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        if (webviewController != null && await webviewController!.canGoBack()) webviewController!.goBack();
                      },
                    ),
                  ),
              ],
            );
          }),
    );
  }
}
