import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/localStorage.dart';

import '/components/c_game_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:game_organizer/globals.dart';
import 'c_my_games_view_model.dart';
export 'c_my_games_view_model.dart';

class CMyGamesViewWidget extends StatefulWidget {
  const CMyGamesViewWidget({Key? key}) : super(key: key);

  @override
  _CMyGamesViewWidgetState createState() => _CMyGamesViewWidgetState();
}

class _CMyGamesViewWidgetState extends State<CMyGamesViewWidget> {
  late CMyGamesViewModel _model;
  late SearchController _searchController;
  late ScrollController _myGamesScrollController;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CMyGamesViewModel());
    _searchController = SearchController();
    _myGamesScrollController = ScrollController(keepScrollOffset: false, initialScrollOffset: myGamesScrollOffset);
    _myGamesScrollController.addListener(() {
      myGamesScrollOffset = _myGamesScrollController.offset;
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      decoration: BoxDecoration(
        color: Color(0x0014181B),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
        child: StreamBuilder<List<GameInfoModel>>(
            stream: LocalStorage().games,
            initialData: LocalStorage().games!.value,
            builder: (context, snapshot) {
              var gamesList = snapshot.data!.where((element) {
                return element.title?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false;
              }).toList();
              return Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SearchAnchor(
                          searchController: _searchController,
                          builder: (context, controller) {
                            return SearchBar(
                              controller: controller,
                              leading: const Icon(Icons.search),
                              constraints: BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 42.0),
                              onChanged: (value) {
                                LocalStorage().games?.add(snapshot.data!);
                              },
                            );
                          },
                          suggestionsBuilder: (context, controller) {
                            return [];
                          },
                        ),
                      ),
                      Flexible(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          controller: _myGamesScrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.4,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: gamesList.length,
                          itemBuilder: (context, index) {
                            return wrapWithModel(
                              model: _model.cGameCardModel,
                              updateCallback: () => setState(() {}),
                              child: CGameCardWidget(gameInfoModel: gamesList[gamesList.length - index - 1]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: FaIcon(
                        FontAwesomeIcons.arrowUp,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      onPressed: () {
                        _myGamesScrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
