import 'package:chaleno/chaleno.dart';
import 'package:game_organizer/models/gameInfo.model.dart';
import 'package:game_organizer/services/localStorage.dart';
import 'package:game_organizer/services/sessionManager.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:http/http.dart' as http;

class Scrapper {
  static final Scrapper _instance = Scrapper._internal();

  factory Scrapper() {
    return _instance;
  }

  Scrapper._internal();

  Browser? _browser;

  static List<String> supportedHosts = ["gofile.io", "pixeldrain.com"];

  Future<void> init() async {
    // _browser = await puppeteer.launch();
  }

  Future<Parser?> getPageParser(String url) async {
    final response = await http.get(Uri.parse(url), headers: SessionManager().getSessionAsMap());
    if (response.statusCode == 200) {
      return Parser(response.body);
    }
  }

  GameInfoModel extractGameInfo(Parser parser) {
    var gameInfoJson = <String, dynamic>{};
    gameInfoJson["engine"] = parser.querySelector(".p-title-value span").text;

    RegExp exp = RegExp(r'(.+)\[(.+)\].+\[(.+)\]');
    var titleMaches = exp.firstMatch(parser.querySelector(".p-title-value").text!)!.groups([1, 2, 3]);
    gameInfoJson["title"] = titleMaches[0];
    gameInfoJson["version"] = titleMaches[1];
    gameInfoJson["author"] = titleMaches[2];

    gameInfoJson["thumbnailUrl"] = parser.querySelector(".bbWrapper img").src;

    return GameInfoModel.fromMap(gameInfoJson);
  }

  List<String?> getSupportedHostsFrommPage(Parser parser) {
    var mainBody = parser.querySelector(".bbWrapper");
    var urlList = mainBody.querySelectorAll("a.link")?.where((link) => supportedHosts.any((host) => link.href!.contains(host)));
    return urlList?.map((e) => e.href).toList() ?? [];
  }

  Future<String?> getRealDownloadUrl(String url) async {
    var browser = await puppeteer.launch();
    var page = await browser.newPage();
    await stopRedirections(page);
    await setPageCookies(page);
    await page.goto(url);

    var uri = Uri.parse(url);

    if (uri.host == "f95zone.to" && uri.path.contains("masked")) {
      uri = Uri.parse(await parseMaskedLink(page));
    }

    String? result;
    switch (uri.host) {
      case "gofile.io":
        result = await fromGoFile(page);
        break;
      case "pixeldrain.com":
        result = fromPixeldrain(uri);
        break;
      default:
    }

    browser.close();

    return result;
  }

  Future<String?> fromGoFile(Page page) async {
    await page.waitForSelector(".contentName");
    var pageContent = await page.content;
    var cookies = await page.cookies();
    if (cookies.isNotEmpty) {
      SessionManager().gofileUserSession = "${cookies[0].name}=${cookies[0].value}";
    }

    page.close();
    var parser = Parser(pageContent);
    return parser.querySelector("#filesContentTableContent").querySelector(".dropdown-item")?.href;
  }

  String fromPixeldrain(Uri uri) {
    return "https://pixeldrain.com/api/file/${uri.pathSegments.last}?download";
  }

  Future<String> parseMaskedLink(Page page) async {
    await page.waitForSelector(".host_link");
    var responseFuture = page.waitForNavigation();
    await page.click(".host_link");

    var response = await responseFuture;

    return response.url;
  }

  Future<void> stopRedirections(Page page) async {
    await page.setRequestInterception(true);
    page.onRequest.listen((request) {
      if (request.isNavigationRequest && request.redirectChain.length > 0) {
        request.abort();
      } else {
        request.continueRequest();
      }
    });
  }

  Future<void> setPageCookies(Page page) async {
    List cookies = LocalStorage().getItem("cookies");
    cookies.forEach((element) {
      element.remove("sameSite");
    });

    await page.setCookies(List.generate(cookies.length, (index) {
      return CookieParam.fromJson(cookies[index]);
    }));
  }
}
