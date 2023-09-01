import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? docId;
  String? name;

  GroupModel(this.docId, this.name);

  GroupModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    name = data["name"];
  }

}
