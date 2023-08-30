import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customFullScreenDialog.dart';
import '../customSnackBar.dart';
import '../models/groupModel.dart';
import '../models/weekModel.dart';

class BaseController extends GetxController {
  List<String> weekData = List<String>.from(["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]);

  RxList<WeekModel> weekList = RxList<WeekModel>([]);
  //Rx<List<EmployeeModel>> employees = Rx<List<EmployeeModel>>([]);

  late WeekModel weekModel;
  var itemCount = 0.obs;



  @override
  void onInit() {
    super.onInit();

    for (var i = 0; i < weekData.length; i++) {
      addEmployee(weekData[i]);
    }

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {

  }


  addEmployee(String name) {
    weekModel = WeekModel(name: name);
    weekList.value.add(weekModel);
    itemCount.value = weekList.value.length;

  }

}
