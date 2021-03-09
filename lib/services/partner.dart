import 'package:as_solar_sales/models/partner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class PartnerService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'partners';

  // void createPartner(String name, String code){
  //   var id = Uuid();
  //   String partner_Id = id.v1();
  //
  //   _firestore.collection(ref).doc(partner_Id).set({'partner': name, 'code': code});
  // }

  Future<List<DocumentSnapshot>> getPartner(String partner) async =>
      _firestore
          .collection(ref)
          .where("partner", isEqualTo: partner)
          .get().then((snaps){

        // List<PartnerModel> partners = [];
        // for (DocumentSnapshot order in snaps.docs) {
        //   partners.add(PartnerModel.fromSnapshot(order));
        // }
        // return partners;
    // print(snaps.docs.length);
    return snaps.docs;
  });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('partner', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });
}