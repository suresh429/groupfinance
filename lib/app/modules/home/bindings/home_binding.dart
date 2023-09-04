import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    //Get.lazyPut<HomeController>(() => HomeController(),fenix: false);
    //Get.putAsync(() async => HomeController);
    Get.put(HomeController(), permanent: true);
  }
}
