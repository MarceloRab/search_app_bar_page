import 'package:get/get.dart';
import '../pages/home/home_page.dart';
import '../pages/search_page/search_page.dart';
import '../pages/search_stream_page/search_app_bar_stream.dart';

/*import 'package:search_app_bar_page/pages/home/home_page.dart';
import 'package:search_app_bar_page/pages/page_1/search_page.dart';
import 'package:search_app_bar_page/pages/page_2/search_app_bar_stream.dart';*/

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.PAGE_1, page: () => SearchPage()),
    GetPage(name: Routes.PAGE_2, page: () => SearchAppBarStream()),
  ];
}
