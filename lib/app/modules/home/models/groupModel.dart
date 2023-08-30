import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? docId;
  String? name;
  String? address;

  GroupModel({this.docId, this.name, this.address});

  GroupModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    name = data["name"];
    address = data["address"];
  }
}
