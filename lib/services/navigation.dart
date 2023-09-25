import "package:flutter/material.dart";
import "package:game_organizer/views/c_my_games_view/c_my_games_view_widget.dart";
import "package:rxdart/rxdart.dart";

class Navigation {
  static final Navigation _instance = Navigation._internal();

  factory Navigation() {
    return _instance;
  }

  Navigation._internal() {
    navigationStream = BehaviorSubject.seeded(homeView);
  }

  get homeView => CMyGamesViewWidget();

  late final BehaviorSubject<Widget> navigationStream;

  void goTo(Function builder) {
    navigationStream.add(builder());
  }
}
