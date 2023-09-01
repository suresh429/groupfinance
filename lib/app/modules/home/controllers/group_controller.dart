import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customFullScreenDialog.dart';
import '../customSnackBar.dart';
import '../models/groupModel.dart';

class GroupController extends GetxController {
  RxBool isLoading = true.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController, addressController;

  // Firestorm operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<GroupModel> groupList = RxList<GroupModel>([]);



  @override
  void onInit() {
    print("STATUS : onInit");
    super.onInit();

    var weekName = Get.arguments['weekName']!;
    nameController = TextEditingController();
    addressController = TextEditingController();
    groupList.clear();
    collectionReference = firebaseFirestore.collection("groups").doc(weekName).collection(weekName);
    groupList.bindStream(getAllGroups());
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Group Name can not be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Address can not be empty";
    }
    return null;
  }




  void saveUpdateGroup(
      String name, String docId, int addEditFlag) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionReference
          .add({'name': name}).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Group Added",
            message: "Group added successfully",
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
          .update({'name': name}).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Group Updated",
            message: "Group updated successfully",
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
    print("STATUS : onReady");

  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    print("STATUS : onClose");
  }

  void clearEditingControllers() {
    nameController.clear();
    addressController.clear();
  }

 /* Stream<List<GroupModel>> getAllGroups() =>
      collectionReference.snapshots().map((query) =>
          query.docs.map((item) => GroupModel.fromMap(item)).toList());*/


  Stream<List<GroupModel>> getAllGroups() {
    groupList.listen((_) {
      isLoading.value = false;
    });

    return collectionReference.snapshots(includeMetadataChanges: true).map(
          (query) {
        isLoading.value = false;
        return query.docs.map((item) => GroupModel.fromMap(item)).toList();
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
          title: "Group Deleted",
          message: "Group deleted successfully",
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
