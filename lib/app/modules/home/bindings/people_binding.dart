import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/controllers/people_controller.dart';

class PeopleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeopleController>(
      () => PeopleController(),
    );
  }
}
