import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerModel {
  // static const ID = "id";
  static const PARTNER = "partner";
  static const CODE = "code";

  // String _id;
  String _partner;
  String _code;

//  getters
//   String get id => _id;

  String get partner => _partner;

  String get code => _code;

  PartnerModel.fromSnapshot(DocumentSnapshot snapshot) {
    // _id = snapshot.data()[ID];
    _partner = snapshot.data()[PARTNER];
    _code = snapshot.data()[CODE];
  }
}
