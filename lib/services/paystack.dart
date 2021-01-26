import 'dart:convert';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:as_solar_sales/services/cards.dart';
// import 'package:as_solar_sales/services/purchases.dart';
import 'package:as_solar_sales/services/users.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'order.dart';


class PaystackServices{
  static const PUBLISHABLE_KEY = "pk_test_bd6dfd236bb9176e980f575121f89c5337fad6ca";
  static const SECRET_KEY = "sk_test_566f7ff3cc84bbe718d6f40a6871e4f185a64452";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.paystack.co/customer";
  static const CHARGE_URL = "https://api.paystack.co/charge";
  Map<String, String> headers = {
    'Authorization': "Bearer $SECRET_KEY",
    "Content-Type": "application/json",
    'Accept': 'application/json'
    // "Content-Type": "application/x-www-form-urlencoded"
  };
  UserProvider userProvider = UserProvider.initialize();
  Future<String> createPaystackCustomer({String email, String userId})async{
    Map data = {
      'email': email,
    };

    String body = json.encode(data);

    // http.Response response = await http.post(CUSTOMERS_URL, body: body, headers: headers);
    //
    // final Map resData = jsonDecode(response.body);
    //
    // String paystackId = resData['data']['customer_code'];
    // // print(paystackId);
    // return paystackId;

    String paystackId = await http.post(CUSTOMERS_URL, body: body, headers: headers).then((response){
      final Map resData = jsonDecode(response.body);
      // final Map paystackId = jsonDecode(response.body);
      String paystackId = resData["data"]['customer_code'];
      print(paystackId);
      print("The stripe id is: $paystackId");
      UserServices userService = UserServices();
      userService.updateDetails({
        "uid": userId,
        "paystackId": paystackId
      });
      return paystackId;
    }).catchError((err){
      print("==== THERE WAS AN ERROR ====: ${err.toString()}");
      return null;
    });


    return paystackId;
  }

  Future<void> addCard({int cardNumber, int month, int year, int cvc, String paystackId, String userId})async{
    Map body = {
      "type": "card",
      "card[number]": cardNumber,
      "card[exp_month]": month,
      "card[exp_year]":year,
      "card[cvc]":cvc
    };
    Dio().post(PAYMENT_METHOD_URL, data: body, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response){
      String paymentMethod = response.data["id"];
      print("=== The payment mathod id id ===: $paymentMethod");
      http.post("https://api.stripe.com/v1/payment_methods/$paymentMethod/attach", body: {
        "customer": paystackId
      },
          headers: headers
      ).catchError((err){
        print("ERROR ATTACHING CARD TO CUSTOMER");
        print("ERROR: ${err.toString()}");

      });

      CardServices cardServices = CardServices();
      cardServices.createCard(id: paymentMethod, last4: int.parse(cardNumber.toString().substring(11)), exp_month: month, exp_year: year, userId: userId);
      UserServices userService = UserServices();
      userService.updateDetails({
        "uid": userId,
        "activeCard": paymentMethod
      });
    }).catchError((err){
      print("Error: ${err.toString()}");
    });
  }



  Future<bool> charge({String customer, int amount, String email, String userId, String cardId, String status, String description, List cart, String productName})async{
    Map<String, dynamic> data ={
      "email":email,
      "amount":amount,
      // "metadata":{
      //   "custom_fields":[
      //     {
      //       "value":"makurdi",
      //       "display_name": "Donation for",
      //       "variable_name": "donation_for"
      //     }
      //   ]
      // },
      "card":{
        "cvv":"408",
        "number":"4084084084084081",
        "expiry_month":"01",
        "expiry_year":"99"
      },
      "pin":"0000"

    };
    try{
      Dio().post(CHARGE_URL, data: data, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response){
        print(response.toString());
      });
      OrderServices orderServices = OrderServices();
      var uuid = Uuid();
      var purchaseId = uuid.v1();
      orderServices.createOrder(
        userId: userId,
        id: purchaseId,
        description: description,
        status: status,
        totalPrice: amount,
        cart: cart,
        cardId: cardId,);
      // orderServices.createOrder(id: purchaseId, amount: amount, cardId: cardId, userId: userId, productName: productName);
      return true;
    }catch(e){
      print("there was an error charging the customer: ${e.toString()}");
      return false;
    }
  }

  // Future<PaymentCard> _getCardFromUI({String cardNumber, int month, int year, String cvc}) async {
  //
  //   // CardServices cardServices = CardServices();
  //   // cardServices.createCard(id: paymentMethod, last4: int.parse(cardNumber.toString().substring(11)), exp_month: month, exp_year: year, userId: userId);
  //   // UserServices userService = UserServices();
  //   // userService.updateDetails({
  //   //   "uid": userId,
  //   //   "activeCard": paymentMethod
  //   // });
  //   // Using just the must-required parameters.
  //   return PaymentCard(
  //     number: cardNumber,
  //     cvc: cvc,
  //     expiryMonth: month,
  //     expiryYear: year,
  //   );
  // }

  // _chargeCard(String accessCode, {String cardNumber, int month, int year, String cvc}) async {
  //   var charge = Charge()
  //     ..accessCode = accessCode
  //     ..card = _getCardFromUI(cardNumber: cardNumber, month: month, year: year, cvc: cvc);
  //
  //   final response = await PaystackPlugin.chargeCard(context, charge: charge);
  //   // Use the response
  // }

}