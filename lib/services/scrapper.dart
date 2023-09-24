import 'package:chaleno/chaleno.dart';
import 'package:game_organizer/services/localStorage.dart';
import 'package:puppeteer/puppeteer.dart';

class Scrapper {
  static final Scrapper _instance = Scrapper._internal();

  factory Scrapper() {
    return _instance;
  }

  Scrapper._internal();

  Browser? _browser;

  Future<void> init() async {
    _browser = await puppeteer.launch();
  }

  Future<String?> getRealDownloadUrl(String url) async {
    var page = await _browser!.newPage();
    await stopRedirections(page);
    await setPageCookies(page);
    await page.goto(url);

    var uri = Uri.parse(url);

    if (uri.host == "f95zone.to" && uri.path.contains("masked")) {
      uri = Uri.parse(await parseMaskedLink(page));
    }

    switch (uri.host) {
      case "gofile.io":
        return await fromGoFile(page);
      case "pixeldrain.com":
        return fromPixeldrain(uri);
      default:
    }
  }

  Future<String?> fromGoFile(Page page) async {
    await page.waitForSelector(".contentName");
    var pageContent = await page.content;

    page.close();
    var parser = Parser(pageContent);
    return parser.querySelector("#filesContentTableContent").querySelector(".dropdown-item")?.href;
  }

  String fromPixeldrain(Uri uri) {
    return "pixeldrain.com/api/file/${uri.pathSegments.last}?download";
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
