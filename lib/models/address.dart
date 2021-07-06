
class AddressModel {
  static const ID = "id";
  static const ADDRESS = "address";

  String _id;
  String _address;
  // String _code;

//  getters
  String get id => _id;
  String get address => _address;

  AddressModel.fromMap(Map data){
    _id = data[ID];
    _address = data[ADDRESS];
  }

  Map toMap() => {
    ID: _id,
    ADDRESS: _address
  };

}
