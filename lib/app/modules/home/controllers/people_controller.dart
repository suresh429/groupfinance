import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customFullScreenDialog.dart';
import '../customSnackBar.dart';
import '../models/PeopleModel.dart';

class PeopleController extends GetxController {
  RxBool isLoading = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController, amountController;

  // Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<PeopleModel> peopleList = RxList<PeopleModel>([]);

  var argumentData = Get.arguments;

  double get listItemTotal => peopleList.fold(0, (sum, item) => sum + (item.amount! * item.quantity!));


  void resetController() {
    onInit(); // Call onInit to perform the initialization again.
  }

  @override
  void onInit() {

    var id = argumentData[0]['id'];
    var weekName = argumentData[1]['weekName'];
    var groupName = argumentData[2]['groupName'];

    nameController = TextEditingController();
    amountController = TextEditingController();
    collectionReference = firebaseFirestore
        .collection("groups")
        .doc(weekName)
        .collection(weekName)
        .doc(id)
        .collection(groupName);
    peopleList.bindStream(getAllPeople());

    super.onInit();

  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? validateAmount(String value) {
    if (value.isEmpty) {
      return "Amount can not be empty";
    }
    return null;
  }

  void saveUpdatePeople(
      String name, String amount, String docId, int addEditFlag) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionReference.add({
        'userName': name,
        'amount': double.parse(amount),
        "quantity": 1
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "User Added",
            message: "User added successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.green);
      });
    } else if (addEditFlag == 2) {
      //update
      CustomFullScreenDialog.showDialog();
      collectionReference
          .doc(docId)
          .update({'userName': name, 'amount': amount}).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "User Updated",
            message: "User updated successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.red);
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
  }

  void clearEditingControllers() {
    nameController.clear();
    amountController.clear();
  }

  /*Stream<List<PeopleModel>> getAllPeople() => collectionReference.snapshots().map((query) =>
          query.docs.map((item) => PeopleModel.fromMap(item)).toList());*/

  Stream<List<PeopleModel>> getAllPeople() {
    peopleList.listen((_) async{
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    });

    return collectionReference.snapshots().map(
      (query) {
        isLoading.value = false;
        return query.docs.map((item) => PeopleModel.fromMap(item)).toList();
      },
    );

  }

  void deleteData(String docId) {
    CustomFullScreenDialog.showDialog();
    collectionReference.doc(docId).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "User Deleted",
          message: "User deleted successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }
}
