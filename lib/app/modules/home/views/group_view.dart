import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/group_controller.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    var weekName = Get.arguments['weekName']!;
    print("weekName $weekName");
    return Scaffold(
      appBar: AppBar(
        title: Text(weekName!),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _buildAddEditEmployeeView(text: 'ADD', addEditFlag: 1, docId: '');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final myData = controller.groupList;
                if (controller.isLoading.value) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Display loading spinner
                }

                return ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) => Card(
                    color: const Color(0xff081029),
                    child: ListTile(
                      title: Text(myData[index].name!),
                      //subtitle: Text(controller.employees[index].address!),
                      leading: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        child: Text(
                          controller.groupList[index].name!
                              .substring(0, 1)
                              .capitalize!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        // color: Colors.red,
                      ),

                      onTap: () async{
                        await Get.toNamed(Routes.PEOPLE, arguments: [
                          {"id": controller.groupList[index].docId!.toString()},
                          {"weekName": weekName!},
                          {"groupName": controller.groupList[index].name!}
                        ]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildAddEditEmployeeView({String? text, int? addEditFlag, String? docId}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          color: Color(0xff1E2746),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${text} Group',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Group Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.nameController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  /* SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.addressController,
                    validator: (value) {
                      return controller.validateAddress(value!);
                    },
                  ),*/
                  const SizedBox(
                    height: 8,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: Get.context!.width, height: 45),
                    child: ElevatedButton(
                      child: Text(
                        text!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        controller.saveUpdateGroup(
                            controller.nameController.text,
                            // controller.addressController.text,
                            docId!,
                            addEditFlag!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Group",
      titleStyle: const TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete group ?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {
        controller.deleteData(docId);
      },
    );
  }
}
