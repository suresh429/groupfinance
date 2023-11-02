import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customFullScreenDialog.dart';
import '../customSnackBar.dart';
import '../models/groupModel.dart';

class GroupController extends GetxController {
  RxBool isLoading = true.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      loanAmountController,
      loanDateController,
      loanRepaymentController,
      totalWeekController,
      penaltyController;

  // Firestorm operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  // RxList<GroupModel> groupList = RxList<GroupModel>([]);
  RxList<GroupModel> groupList = <GroupModel>[].obs;

  void resetController() {
    onInit(); // Call onInit to perform the initialization again.
  }

  @override
  void onInit() {
    print("STATUS : onInit GROUP");
    var weekName = Get.arguments['weekName']!;
    nameController = TextEditingController();
    loanAmountController = TextEditingController();
    loanDateController = TextEditingController();
    loanRepaymentController = TextEditingController();
    totalWeekController = TextEditingController();
    penaltyController = TextEditingController();
    penaltyController.text = "200";

   // groupList.clear();
    collectionReference = firebaseFirestore
        .collection("groups")
        .doc(weekName)
        .collection(weekName);
    groupList.bindStream(getAllGroups());
    // _loadTodos();
    super.onInit();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Group Name can not be empty";
    }
    return null;
  }

  String? validateLoanAmount(String value) {
    if (value.isEmpty) {
      return "Loan Amount can not be empty";
    }
    return null;
  }

  String? validateDate(String value) {
    if (value.isEmpty) {
      return "Loan Date can not be empty";
    }
    return null;
  }

  String? validateLoanRepayment(String value) {
    if (value.isEmpty) {
      return "Loan Repayment can not be empty";
    }
    return null;
  }

  String? validateTotalWeeks(String value) {
    if (value.isEmpty) {
      return "Total Weeks can not be empty";
    }
    return null;
  }

  String? validatePenalty(String value) {
    if (value.isEmpty) {
      return "Penalty can not be empty";
    }
    return null;
  }

  void saveUpdateGroup(
      String groupName,
      String loanAmount,
      String date,
      String repayment,
      String totalWeeks,
      String penalty,
      String docId,
      int addEditFlag) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionReference
          .add({
        'groupName': groupName,
        'loanAmount': double.parse(loanAmount),
        'date': date,
        'repayment': double.parse(repayment),
        'totalWeeks': int.parse(totalWeeks.toString()),
        'penalty': double.parse(penalty),
      })
          .then((_) {
        // Success case
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Group Added",
            message: "Group added successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        // Error case
        print("ERROR : " + error.toString());
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.red);
      });
    } else if (addEditFlag == 2) {
      //update
      CustomFullScreenDialog.showDialog();
      collectionReference.doc(docId).update({
        'groupName': groupName,
        'loanAmount': double.parse(loanAmount),
        'date': date,
        'repayment': double.parse(repayment),
        'totalWeeks': int.parse(totalWeeks.toString()),
        'penalty': double.parse(penalty)
      }).whenComplete(() {
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
  void onClose() {
    nameController.dispose();
    loanAmountController.dispose();
    loanDateController.dispose();
    loanRepaymentController.dispose();
    totalWeekController.dispose();
    penaltyController.dispose();
  }

  void clearEditingControllers() {
    nameController.clear();
    loanAmountController.clear();
    loanDateController.clear();
    loanRepaymentController.clear();
    totalWeekController.clear();
    penaltyController.clear();
  }

  /* Stream<List<GroupModel>> getAllGroups() =>
      collectionReference.snapshots().map((query) =>
          query.docs.map((item) => GroupModel.fromMap(item)).toList());*/

  Stream<List<GroupModel>> getAllGroups() {
    groupList.listen((_) async {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    });

    return collectionReference.snapshots(includeMetadataChanges: true).map(
      (query) {
        isLoading.value = false;
        return query.docs.map((item) => GroupModel.fromMap(item)).toList();
      },
    );
  }

  Future<void> _loadTodos() async {
    isLoading.value = true; // Set loading to true when fetching data
    await Future.delayed(const Duration(seconds: 2));
    final QuerySnapshot querySnapshot = await collectionReference.get();
    groupList.value =
        querySnapshot.docs.map((item) => GroupModel.fromMap(item)).toList();
    isLoading.value = false; // Set loading to false when data is fetched
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
