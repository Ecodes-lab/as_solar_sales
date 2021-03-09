import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProductServices {
  String collection = "products";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async =>
       _firestore.collection(collection).get().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        // result.docs.map((DocumentSnapshot snapshot) => products.add(ProductModel.fromSnapshot(snapshot)));
        return products;
      });

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values["id"]).update(values);
  }


  Future<List<ProductModel>> searchProducts({String productName}) async {
    // code to convert the first character to uppercase
    // ChangeNotifierProvider.value(value: ProductProvider.initialize());
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        // .where("name", isEqualTo: productName)
        .get()
        .then((result) {
      List<ProductModel> products = [];
      for (DocumentSnapshot product in result.docs) {
        products.add(ProductModel.fromSnapshot(product));
      }
      return products;
    });
  }
}
