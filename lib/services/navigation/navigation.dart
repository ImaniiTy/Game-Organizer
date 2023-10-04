import "package:game_organizer/views/c_my_games_view/c_my_games_view_widget.dart";
import "package:rxdart/rxdart.dart";

import "routes.dart";

class Navigation {
  static final Navigation _instance = Navigation._internal();

  factory Navigation() {
    return _instance;
  }

  Navigation._internal() {
    navigationStream = BehaviorSubject.seeded(Routes.names.values.first);
  }

  get homeView => CMyGamesViewWidget();

  late final BehaviorSubject<NavigationContext> navigationStream;

  void goTo(String name, {Map<String, String>? params}) {
    if (Routes.names[name] != null) {
      Routes.names[name]!.params = params;
      navigationStream.add(Routes.names[name]!);
    }
  }
}

class NavigationContext {
  final Function builder;
  final String name;
  Map<String, String>? params;

  NavigationContext(this.builder, this.name);
}
