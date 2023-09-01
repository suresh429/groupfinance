import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/controllers/people_controller.dart';

import '../controllers/group_controller.dart';

class PeopleView extends GetView<PeopleController> {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    var argumentData = Get.arguments;

    var id = argumentData[0]['id'];
    var weekName = argumentData[1]['weekName'];
    var groupName = argumentData[2]['groupName'];

    double sum = 0.0;
    print("Cart Total: \$${controller.listItemTotal.toStringAsFixed(2)}");

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _buildAddEditEmployeeView(text: 'ADD', addEditFlag: 1, docId: '');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Display loading spinner
                  }
                  return ListView.builder(
                    itemCount: controller.peopleList.length,
                    itemBuilder: (context, index) => Card(
                      color: const Color(0xff081029),
                      child: ListTile(
                        title: Text(controller.peopleList[index].userName!),
                        subtitle: Text(
                            "\u20b9 ${controller.peopleList[index].amount!.toStringAsFixed(2)}"),
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: Text(
                            controller.peopleList[index].userName!
                                .substring(0, 1)
                                .capitalize!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            displayDeleteDialog(
                                controller.peopleList[index].docId!);
                          },
                        ),
                        onTap: () {
                          controller.nameController.text =
                              controller.peopleList[index].userName!;
                          // controller.addressController.text = controller.employees[index].address!;
                          /*_buildAddEditEmployeeView(
                            text: 'UPDATE',
                            addEditFlag: 2,
                            docId: controller.employees[index].docId!);*/
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Colors.yellow
                      // fromHeight use double.infinity as width and 40 is the height
                      ),
                  onPressed: () {},
                  child: Text(
                    "Total Amount : \u20b9 ${controller.listItemTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ))
          ],
        ),
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
                    '${text} People',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.nameController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.amountController,
                    validator: (value) {
                      return controller.validateAmount(value!);
                    },
                  ),
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
                        controller.saveUpdatePeople(
                            controller.nameController.text.toString(),
                            controller.amountController.text.toString(),
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
      title: "Delete Employee",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete employee ?',
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
