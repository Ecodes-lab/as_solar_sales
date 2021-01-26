import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:as_solar_sales/models/cards.dart';
import 'package:as_solar_sales/models/user.dart';

class CardServices{
  static const USER_ID = 'userId';

  String collection = "cards";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createCard({String id, String userId, int exp_month, int exp_year, int last4}){
    _firestore.collection(collection).doc(id).set({
      "id": id,
      "userId": userId,
      "exp_month": exp_month,
      "exp_year":exp_year,
      "last4": last4
    });
  }

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values["id"]).update(values);
  }

  void deleteCard(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values["id"]).delete();
  }

  Future<List<CardModel>> getPurchaseHistory({String customerId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: customerId).get().then((result){
        List<CardModel> listOfCards = [];
        result.docs.map((item){
          listOfCards.add(CardModel.fromSnapshot(item));
        });
        return listOfCards;
      });

  Future<List<CardModel>> getCards({String userId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: userId).get().then((result){
        List<CardModel> cards = [];
        print("=== RESULT SIZE ${result.docs.length}");
        for(DocumentSnapshot item in result.docs){
          cards.add(CardModel.fromSnapshot(item));
          print(" CARDS ${cards.length}");
        }
        return cards;
      });
}