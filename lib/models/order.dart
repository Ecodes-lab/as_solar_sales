import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const ADDRESS = "address";
  static const PHONENO = "phoneNo";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String _id;
  String _description;
  String _address;
  String _phoneNo;
  String _userId;
  String _status;
  int _createdAt;
  int _total;

  List _cart;

//  getters
  String get id => _id;

  String get description => _description;

  String get address => _address;

  String get phoneNo => _phoneNo;

  String get userId => _userId;

  String get status => _status;

  int get total => _total;

  int get createdAt => _createdAt;

  // public variable
  List get cart => _cart;



  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    _id = data[ID];
    _description = data[DESCRIPTION];
    _address = data[ADDRESS] ?? "";
    _phoneNo = data[PHONENO] ?? "";
    _total = data[TOTAL];
    _status = data[STATUS];
    _userId = data[USER_ID];
    _createdAt = data[CREATED_AT];
    _cart = data[CART] ?? [];
  }
}
