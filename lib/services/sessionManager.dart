import 'package:game_organizer/services/localStorage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? _gofileUserSession;
  String? get gofileUserSession => _gofileUserSession ?? LocalStorage().getItem("gofileUserSession");
  set gofileUserSession(String? value) {
    _gofileUserSession = value;
    LocalStorage().setItem("gofileUserSession", _gofileUserSession);
  }

  Map<String, String> getSessionAsMap() {
    return {"cookie": getSessionAsString()};
  }

  String getSessionAsString() {
    var f95UserSession = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");
    return "xf_session=${f95UserSession["value"]};${gofileUserSession ?? ""}";
  }
}
