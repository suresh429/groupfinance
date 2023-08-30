import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/controllers/base_controller.dart';
import 'package:groupfinance/app/modules/home/views/home_view.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dash Board'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.weekList.length,
          itemBuilder: (context, index) => Card(
            color: const Color(0xff081029),
            child: ListTile(
              title: Text(controller.weekList[index].name!),
              leading: CircleAvatar(
                backgroundColor: Colors.yellow,
                child: Text(
                  controller.weekList[index].name!.substring(0, 1).capitalize!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              onTap: () {

                var args = {'data': controller.weekList[index].name};
                Get.toNamed(Routes.HOME, arguments: args);


              },
            ),
          ),
        ),
      ),
    );
  }

}
