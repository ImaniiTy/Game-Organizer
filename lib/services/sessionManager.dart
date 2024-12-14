import 'package:game_organizer/services/localStorage.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? _gofileUserSession;
  String? get gofileUserSession => _gofileUserSession ?? LocalStorage().getItem("accountToken");
  set gofileUserSession(String? value) {
    _gofileUserSession = value;
    LocalStorage().setItem("accountToken", _gofileUserSession);
  }

  String downloadCookies = "";

  void setDownloadCookies(String value) => downloadCookies = value;

  Map<String, String> getSessionAsMap() {
    return {"cookie": getSessionAsString()};
  }

  String getSessionAsString() {
    // var f95UserSession = LocalStorage().getItem("cookies").firstWhere((cookie) => cookie["name"] == "xf_session");
    var f95UserCookies = LocalStorage().getItem("cookies");
    StringBuffer strBuffer = StringBuffer();

    for (var cookie in f95UserCookies) {
      strBuffer.write("${cookie["name"]}=${cookie["value"]};");
    }

    if (gofileUserSession != null) strBuffer.write(gofileUserSession);

    return strBuffer.toString();
  }
}
