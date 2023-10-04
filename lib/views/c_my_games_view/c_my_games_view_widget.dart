import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/localStorage.dart';

import '/components/c_game_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_my_games_view_model.dart';
export 'c_my_games_view_model.dart';

class CMyGamesViewWidget extends StatefulWidget {
  const CMyGamesViewWidget({Key? key}) : super(key: key);

  @override
  _CMyGamesViewWidgetState createState() => _CMyGamesViewWidgetState();
}

class _CMyGamesViewWidgetState extends State<CMyGamesViewWidget> {
  late CMyGamesViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CMyGamesViewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

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
              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.4,
                ),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return wrapWithModel(
                    model: _model.cGameCardModel,
                    updateCallback: () => setState(() {}),
                    child: CGameCardWidget(gameInfoModel: snapshot.data![index]),
                  );
                },
              );
            }),
      ),
    );
  }
}
