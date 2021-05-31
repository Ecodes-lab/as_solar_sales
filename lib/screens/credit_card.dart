import 'package:as_solar_sales/services/paystack.dart';
import 'package:as_solar_sales/services/paystack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/screens/products.dart';
import 'package:as_solar_sales/services/functions.dart';
import 'package:as_solar_sales/services/stripe.dart';
import 'package:provider/provider.dart';

class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused, //true when you want to show cvv(back) view
              ),
              CreditCardForm(
                themeColor: Colors.red,
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                    isCvvFocused = data.isCvvFocused;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          int cvc = int.tryParse(cvvCode);
          int carNo = int.tryParse(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
          int exp_year = int.tryParse(expiryDate.substring(3,5));
          int exp_month = int.tryParse(expiryDate.substring(0,2));

          print("cvc num: ${cvc.toString()}");
          print("card num: ${carNo.toString()}");
          print("exp year: ${exp_year.toString()}");
          print("exp month: ${exp_month.toString()}");
          print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
//
          PaystackServices paystackServices = PaystackServices();
          if(user.userModel.stripeId == null){
           String paystackID = await paystackServices.createPaystackCustomer(email: user.userModel.email, userId: user.user.uid);
           print("stripe id: $paystackID");
           print("stripe id: $paystackID");
           print("stripe id: $paystackID");
           print("stripe id: $paystackID");

           paystackServices.addCard(paystackId: paystackID, month: exp_month, year: exp_year, cvc: cvc, cardNumber: carNo, userId: user.user.uid);
          }else{
            paystackServices.addCard(paystackId: user.userModel.paystackId, month: exp_month, year: exp_year, cvc: cvc, cardNumber: carNo, userId: user.user.uid);
          }
        user.hasCard();
          user.loadCardsAndPurchase(userId: user.user.uid);

          changeScreenReplacement(context, ProductPage());

        },
        tooltip: 'Submit',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}