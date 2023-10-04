import 'package:game_organizer/flutter_flow/flutter_flow_util.dart';
import 'package:game_organizer/views/c_my_games_view/c_my_games_view_widget.dart';
import 'package:game_organizer/views/c_ssttings_view/c_ssttings_view_widget.dart';
import 'package:game_organizer/views/c_web_view/c_web_view_widget.dart';

import 'navigation.dart';

class Routes {
  static Map<String, NavigationContext> names = {
    "/MyGames": NavigationContext(
      (context, params) {
        return wrapWithModel<CMyGamesViewModel>(
          model: createModel(context, () => CMyGamesViewModel()),
          updateCallback: () {},
          child: CMyGamesViewWidget(),
        );
      },
      "/MyGames",
    ),
    "/WebView": NavigationContext(
      (context, params) {
        return wrapWithModel<CWebViewModel>(
          model: createModel(context, () => CWebViewModel()),
          updateCallback: () {},
          child: CWebViewWidget(params: params),
        );
      },
      "/WebView",
    ),
    "/Settings": NavigationContext(
      (context, params) {
        return wrapWithModel<CSsttingsViewModel>(
          model: createModel(context, () => CSsttingsViewModel()),
          updateCallback: () {},
          child: CSsttingsViewWidget(),
        );
      },
      "/Settings",
    ),
  };
}
