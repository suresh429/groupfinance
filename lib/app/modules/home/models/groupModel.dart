import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? docId;
  String? groupName;
  dynamic loanAmount;
  String? date;
  dynamic repayment;
  dynamic totalWeeks;
  dynamic penalty;

  GroupModel(this.docId, this.groupName, this.loanAmount, this.date,
      this.repayment, this.totalWeeks, this.penalty);

  GroupModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    groupName = data["groupName"];
    loanAmount = data["loanAmount"].toDouble();
    date = data["date"];
    repayment = data["repayment"];
    totalWeeks = data["totalWeeks"];
    penalty = data["penalty"];
  }
}
