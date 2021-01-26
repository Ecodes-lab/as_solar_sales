import 'dart:convert';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:as_solar_sales/services/cards.dart';
// import 'package:as_solar_sales/services/purchases.dart';
import 'package:as_solar_sales/services/users.dart';
import 'package:uuid/uuid.dart';

import 'order.dart';


class StripeServices{
  static const PUBLISHABLE_KEY = "pk_test_51I8WADBiMnVsZjlccOlsv7rai1KtQy3qWckoJ9GrOD5uTpczIj60fg822vWttN9602HXLXVVE7oxhhzKYCPvYDAo00B1hcR7KT";
  static const SECRET_KEY = "sk_test_51I8WADBiMnVsZjlcqHLMk16Xe66qX2VhJroQqsKi0WmdpCygqeXm93zQl54jeQGPn4pGuY3vzokrY4Jnd9Mof2Le00PyTkRZBc";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
  static const CHARGE_URL = "https://api.stripe.com/v1/charges";
  Map<String, String> headers = {
    'Authorization': "Bearer  $SECRET_KEY",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  UserProvider userProvider = UserProvider.initialize();
  Future<String> createStripeCustomer({String email, String userId})async{
    Map<String, String> body = {
      'email': email,
    };

    String stripeId = await http.post(CUSTOMERS_URL, body: body, headers: headers).then((response){
     String stripeId = jsonDecode(response.body)["id"];
      print("The stripe id is: $stripeId");
      UserServices userService = UserServices();
      userService.updateDetails({
        "uid": userId,
        "stripeId": stripeId
      });
      return stripeId;
    }).catchError((err){
      print("==== THERE WAS AN ERROR ====: ${err.toString()}");
      return null;
    });

    return stripeId;
  }

  Future<void> addCard({int cardNumber, int month, int year, int cvc, String stripeId, String userId})async{
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
        "customer": stripeId
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

  Future<bool> charge({String customer, int amount, String userId, String cardId, String status, String description, List cart, String productName})async{
    Map<String, dynamic> data ={
      "amount": amount,
      "currency": "ng",
      "source": cardId,
      "customer": customer
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

}