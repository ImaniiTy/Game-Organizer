import 'package:game_organizer/services/localStorage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? gofileUserSession;

  Map<String, String> getSessionAsMap() {
    return {"cookie": getSessionAsString()};
  }

  String getSessionAsString() {
    var f95UserSession = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");
    return "xf_session=${f95UserSession["value"]};${gofileUserSession ?? ""}";
  }
}
