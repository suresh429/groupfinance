import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleModel {
  String? docId;
  String? userName;
  //String? amount;
  double? amount;
  int? quantity;

  PeopleModel({this.docId, this.userName, this.amount,this.quantity});

  PeopleModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    userName = data["userName"];
    amount = data["amount"];
    quantity = data["quantity"];
  }


}
