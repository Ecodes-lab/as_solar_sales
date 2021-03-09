import 'dart:async';
import 'dart:io';
import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/cart_item.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/services/order.dart';
import 'package:as_solar_sales/services/paystack.dart';
import 'package:as_solar_sales/services/paystack.dart';
import 'package:as_solar_sales/services/product.dart';
import 'package:as_solar_sales/services/stripe.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

// To get started quickly, change this to your heroku deployment of
// https://github.com/PaystackHQ/sample-charge-card-backend
// Step 1. Visit https://github.com/PaystackHQ/sample-charge-card-backend
// Step 2. Click "Deploy to heroku"
// Step 3. Login with your heroku credentials or create a free heroku account
// Step 4. Provide your secret key and an email with which to start all test transactions
// Step 5. Replace {YOUR_BACKEND_URL} below with the url generated by heroku (format https://some-url.herokuapp.com)
// String backendUrl = 'https://api.paystack.co/transaction/initialize';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
String paystackPublicKey = 'pk_test_bd6dfd236bb9176e980f575121f89c5337fad6ca';
const String appName = 'Paystack Example';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  String _fullName;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);



    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Shopping Cart"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.cart.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: red.withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            userProvider.userModel.cart[index].image,
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "${userProvider.userModel.cart[index].name}".toUpperCase() +"\n",
                                        style: GoogleFonts.lato(textStyle: TextStyle(
                                            color: black,
                                            // fontSize: 17,
                                            fontWeight: FontWeight.bold))),
                                    TextSpan(
                                        text:
                                            "\$${userProvider.userModel.cart[index].price / 100} \n\n",
                                            style: GoogleFonts.lato(textStyle: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w400,
                                              // fontSize: 18
                                            ),
                                            )),
                                  ]),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: red,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool success =
                                        await userProvider.removeFromCart(
                                            cartItem: userProvider
                                                .userModel.cart[index]);
                                    if (success) {
                                      userProvider.reloadUserModel();
                                      print("Item added to cart");
                                      _key.currentState.showSnackBar(SnackBar(
                                          content: Text("Removed from Cart!")));
                                      appProvider.changeIsLoading();
                                      return;
                                    } else {
                                      appProvider.changeIsLoading();
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Total: ",
                        style: GoogleFonts.lato(textStyle: TextStyle(
                            color: grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 22),
                        )),
                    TextSpan(
                        text: "NGN ${userProvider.userModel.totalCartPrice / 100}",
                        style: GoogleFonts.lato(textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 22),
                        )
                    )
                  ]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.green[800]),
                child: FlatButton(
                    onPressed: () async {
                      // PaystackServices paystackServices = PaystackServices();
                      // if(userProvider.userModel.paystackId == null){
                      //   String paystackID = await paystackServices.createPaystackCustomer(email: userProvider.userModel.email, userId: userProvider.user.uid);
                      //   print("stripe id: $paystackID");
                      //   print("stripe id: $paystackID");
                      //   print("stripe id: $paystackID");
                      //   print("stripe id: $paystackID");
                      //
                      // }
                      if (userProvider.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Your cart is emty',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      _handleCheckout(context, userProvider);
                      // var uuid = Uuid();
                      // String id = uuid.v4();
                      // _orderServices.createOrder(
                      //     userId: userProvider.user.uid,
                      //     id: id,
                      //     description:
                      //     "Some random description",
                      //     status: "complete",
                      //     totalPrice: userProvider
                      //         .userModel.totalCartPrice,
                      //     cart: userProvider
                      //         .userModel.cart,
                      //     cardId: null);
                      //     PaystackServices paystackServices = PaystackServices() ;
                      //     //              1000 is equal to $10.00
                      //         paystackServices.charge(
                      //             userId: userProvider.user.uid,
                      //             // id: id,
                      //             description:
                      //             "Some random description",
                      //             status: "complete",
                      //             amount: userProvider
                      //                 .userModel.totalCartPrice,
                      //             cart: userProvider
                      //                 .userModel.cart,
                      //             // cardId: null
                      //             cardId: userProvider.userModel.activeCard
                      //         ).then((value) {
                      //           userProvider.loadCardsAndPurchase(
                      //               userId: userProvider.user
                      //                   .uid);
                      //           // if (value) {
                      //           //   changeScreen(
                      //           //       context, Success());
                      //           // } else {
                      //           //   print(
                      //           //       "we have a payment error");
                      //           //   print(
                      //           //       "we have a payment error");
                      //           //   print(
                      //           //       "we have a payment error");
                      //           //
                      //           //   //                  _key.currentState.showSnackBar(
                      //           //   //                      SnackBar(content: Text("Payment failed")));
                      //           // };
                      //         });
                      // for (CartItemModel cartItem
                      // in userProvider
                      //     .userModel.cart) {
                      //   bool value = await userProvider
                      //       .removeFromCart(
                      //       cartItem: cartItem);
                      //   if (value) {
                      //     userProvider.reloadUserModel();
                      //     print("Item added to cart");
                      //     _key.currentState.showSnackBar(
                      //         SnackBar(
                      //             content: Text(
                      //                 "Removed from Cart!")));
                      //   } else {
                      //     print("ITEM WAS NOT REMOVED");
                      //   }
                      // }
                      // _key.currentState.showSnackBar(
                      //     SnackBar(
                      //         content: Text(
                      //             "Order created!")));
                      // Navigator.pop(context);
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Dialog(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20.0)),
                      //         //this right here
                      //         child: Container(
                      //           height: 200,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12.0),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   'You will be charged \$${userProvider.userModel.totalCartPrice / 100} upon delivery!',
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 320.0,
                      //                   child: RaisedButton(
                      //                     onPressed: () async {
                      //
                      //                       var uuid = Uuid();
                      //                       String id = uuid.v4();
                      //                       _orderServices.createOrder(
                      //                           userId: userProvider.user.uid,
                      //                           id: id,
                      //                           description:
                      //                               "Some random description",
                      //                           status: "complete",
                      //                           totalPrice: userProvider
                      //                               .userModel.totalCartPrice,
                      //                           cart: userProvider
                      //                               .userModel.cart,
                      //                           cardId: null);
                      //                       //     PaystackServices paystackServices = PaystackServices() ;
                      //                       //     //              1000 is equal to $10.00
                      //                       //         paystackServices.charge(
                      //                       //             userId: userProvider.user.uid,
                      //                       //             // id: id,
                      //                       //             description:
                      //                       //             "Some random description",
                      //                       //             status: "complete",
                      //                       //             amount: userProvider
                      //                       //                 .userModel.totalCartPrice,
                      //                       //             cart: userProvider
                      //                       //                 .userModel.cart,
                      //                       //             // cardId: null
                      //                       //             cardId: userProvider.userModel.activeCard
                      //                       //         ).then((value) {
                      //                       //           userProvider.loadCardsAndPurchase(
                      //                       //               userId: userProvider.user
                      //                       //                   .uid);
                      //                       //           // if (value) {
                      //                       //           //   changeScreen(
                      //                       //           //       context, Success());
                      //                       //           // } else {
                      //                       //           //   print(
                      //                       //           //       "we have a payment error");
                      //                       //           //   print(
                      //                       //           //       "we have a payment error");
                      //                       //           //   print(
                      //                       //           //       "we have a payment error");
                      //                       //           //
                      //                       //           //   //                  _key.currentState.showSnackBar(
                      //                       //           //   //                      SnackBar(content: Text("Payment failed")));
                      //                       //           // };
                      //                       //         });
                      //                         for (CartItemModel cartItem
                      //                           in userProvider
                      //                               .userModel.cart) {
                      //                         bool value = await userProvider
                      //                             .removeFromCart(
                      //                                 cartItem: cartItem);
                      //                         if (value) {
                      //                           userProvider.reloadUserModel();
                      //                           print("Item added to cart");
                      //                           _key.currentState.showSnackBar(
                      //                               SnackBar(
                      //                                   content: Text(
                      //                                       "Removed from Cart!")));
                      //                         } else {
                      //                           print("ITEM WAS NOT REMOVED");
                      //                         }
                      //                       }
                      //                       _key.currentState.showSnackBar(
                      //                           SnackBar(
                      //                               content: Text(
                      //                                   "Order created!")));
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: Text(
                      //                       "Accept",
                      //                       style:
                      //                           TextStyle(color: Colors.white),
                      //                     ),
                      //                     color: const Color(0xFF1BC0C5),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 320.0,
                      //                   child: RaisedButton(
                      //                       onPressed: () {
                      //                         Navigator.pop(context);
                      //                       },
                      //                       child: Text(
                      //                         "Reject",
                      //                         style: TextStyle(
                      //                             color: Colors.white),
                      //                       ),
                      //                       color: red),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     });
                    },
                    child: Text(
                      "Check out",
                      style: GoogleFonts.lato(textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleCheckout(BuildContext context, userProvider ) async {

    PaystackServices paystackServices = PaystackServices();
    if(userProvider.userModel.paystackId == null){
      String paystackID = await paystackServices.createPaystackCustomer(email: userProvider.userModel.email, userId: userProvider.user.uid);
      // print("stripe id: $paystackID");
      // print("stripe id: $paystackID");
      // print("stripe id: $paystackID");
      // print("stripe id: $paystackID");

    }

    setState(() => _inProgress = true);
    // _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = userProvider.userModel.totalCartPrice // In base currency
      ..email = userProvider.userModel.email
      ..card = _getCardFromUI();

      charge.reference = _getReference();

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        logo: MyLogo()
      ).then((value) async {
        // print(value);
        if(value.status == true){

          var uuid = Uuid();
          String id = uuid.v4();
          _orderServices.createOrder(
              userId: userProvider.user.uid,
              id: id,
              description:
              "Some random description",
              status: "complete",
              totalPrice: userProvider.userModel.totalCartPrice,
              cart: userProvider
                  .userModel.cart,
              cardId: null);

          // ProductServices productService = ProductServices();
          // ProductProvider productProvider = ProductProvider.initialize();
          // productService.updateDetails({
          //   "id": productProvider,
          //   "quantity": await productService.
          // });

          for (CartItemModel cartItem
          in userProvider
              .userModel.cart) {
            bool value = await userProvider.removeFromCart(cartItem: cartItem);
            if (value) {
              userProvider.reloadUserModel();
              print("Item added to cart");
              _key.currentState.showSnackBar(
                  SnackBar(
                      content: Text(
                          "Removed from Cart!")));
            } else {
              print("ITEM WAS NOT REMOVED");
            }
          }
          _key.currentState.showSnackBar(
              SnackBar(
                  content: Text(
                      "Order created!")));
          Navigator.pop(context);

        }
          return value;
      });
      print('Response = $response');
      setState(() => _inProgress = false);
      _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
      // name: _fullName,
    );

  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    try {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(message),
        duration: duration,
        action: new SnackBarAction(
            label: 'CLOSE',
            onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
      ));

    } catch (e) {

    }
  }
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "AS",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
