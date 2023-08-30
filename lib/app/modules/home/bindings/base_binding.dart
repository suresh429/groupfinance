import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/controllers/base_controller.dart';

import '../controllers/home_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(
      () => BaseController(),
    );
  }
}
