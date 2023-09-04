import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/bindings/group_binding.dart';
import 'package:groupfinance/app/modules/home/controllers/home_controller.dart';
import 'package:groupfinance/app/modules/home/views/group_view.dart';

import '../../../routes/app_pages.dart';
import '../controllers/group_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});


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
              onTap: () async {
                var args = {'weekName': controller.weekList[index].name};
                await Get.toNamed(Routes.GROUP,arguments: args,);
               // Get.put(GroupController());
              },
            ),
          ),
        ),
      ),
    );
  }

}
