import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/bindings/home_binding.dart';
import 'package:groupfinance/app/modules/home/bindings/people_binding.dart';
import 'package:groupfinance/app/modules/home/views/home_view.dart';
import 'package:groupfinance/app/modules/home/views/people_view.dart';

import '../modules/home/bindings/group_binding.dart';
import '../modules/home/views/group_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.GROUP,
      page: () => const GroupView(),
      binding: GroupBinding(),
    ),

    GetPage(
      name: _Paths.PEOPLE,
      page: () => const PeopleView(),
      binding: PeopleBinding(),
    ),
  ];
}
