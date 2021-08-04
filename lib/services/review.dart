// import 'package:as_solar_sales/models/cart_item.dart';
import 'package:as_solar_sales/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewServices{
  String collection = "reviews";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createReview({String userId ,String id, String productId, String productName, String productImage, int rating, String comment, String status}) {
    // List<Map> convertedCart = [];

    // for(CartItemModel item in cart){
    //   convertedCart.add(item.toMap());
    // }

    _firestore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "rating": rating,
      "comment": comment,
      "status": status,
      "productId": productId,
      "productName": productName,
      "productImage": productImage
    });
  }

  Future<List<ReviewModel>> getUserReviews({String productId}) async =>
      _firestore
          .collection(collection)
          .where("productId", isEqualTo: productId)
          // .where("status", isEqualTo: "approved")
          // .where("userId", isEqualTo: "approved")
          .get()
          .then((result) {
        List<ReviewModel> reviews = [];
        for (DocumentSnapshot review in result.docs) {
          reviews.add(ReviewModel.fromSnapshot(review));
        }
        return reviews;
      });

  Future<List<ReviewModel>> getUserApprovedReviews({String productId}) async =>
      _firestore
          .collection(collection)
          .where("productId", isEqualTo: productId)
          .where("status", isEqualTo: "approved")
      // .where("userId", isEqualTo: "approved")
          .get()
          .then((result) {
        List<ReviewModel> reviews = [];
        for (DocumentSnapshot review in result.docs) {
          reviews.add(ReviewModel.fromSnapshot(review));
        }
        return reviews;
      });

}