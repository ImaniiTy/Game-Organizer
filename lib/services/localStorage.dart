import 'dart:convert';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/downloadManager.dart';
import 'package:game_organizer/services/processHelper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:localstorage/localstorage.dart' as storage;

enum Collections { cookies, games }

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  final storage.LocalStorage localStorage = storage.LocalStorage('localStorage.json', "./local");
  BehaviorSubject<List<GameInfoModel>>? games;

  Future<void> init() async {
    await localStorage.ready;
    await FastCachedImageConfig.init(subDir: "/cache", clearCacheAfter: const Duration(days: 999));
    List<GameInfoModel>? gamesList =
        getItem(Collections.games.name)?.map<GameInfoModel>((e) => GameInfoModel.fromJson(e)).toList();
    games = BehaviorSubject.seeded(gamesList ?? []);
  }

  dynamic getItem(String key) {
    return localStorage.getItem(key);
  }

  Future<void> setItem(
    String key,
    dynamic value, [
    Object Function(Object)? toEncodable,
  ]) async {
    await localStorage.setItem(key, value, toEncodable);
  }

  void notifyListChanged({bool persiste = false}) {
    games!.add(games!.value);
    if (persiste) setItem(Collections.games.name, games!.value);
  }

  void addGameToLibrary(GameInfoModel gameInfoModel) {
    if (games!.value.contains(gameInfoModel)) {
      updateGameInfoModel(gameInfoModel);
    } else {
      games!.value.add(gameInfoModel);
      notifyListChanged(persiste: true);
    }
  }

  void removeGameFromLibrary(GameInfoModel gameInfoModel) {
    games!.value.remove(gameInfoModel);
    ProcessHelper().deleteFolder(
        "${ProcessHelper().gamesFolder}/${DownloadManager.getFilenNameFromGameInfo(gameInfoModel).split(".zip").first}");
    notifyListChanged(persiste: true);
  }

  void updateGameInfoModel(GameInfoModel gameInfoModel) {
    games!.value[games!.value.indexOf(gameInfoModel)] = gameInfoModel;
    notifyListChanged(persiste: true);
  }
}
