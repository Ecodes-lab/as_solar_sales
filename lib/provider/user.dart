import 'dart:async';

import 'package:as_solar_sales/models/cart_item.dart';
import 'package:as_solar_sales/models/order.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/models/user.dart';
import 'package:as_solar_sales/models/cards.dart';
import 'package:as_solar_sales/provider/product.dart';
// import 'package:as_solar_sales/models/purchase.dart';
import 'package:as_solar_sales/services/order.dart';
import 'package:as_solar_sales/services/users.dart';
import 'package:as_solar_sales/services/cards.dart';
// import 'package:as_solar_sales/services/purchases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated, ConfirmEmail }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;

  final _key = GlobalKey<ScaffoldState>();

  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  CardServices _cardServices  = CardServices();
  // PurchaseServices _purchaseServices = PurchaseServices();

  UserModel _userModel;
  List<CardModel> cards = [];
  // List<PurchaseModel> purchaseHistory = [];

  dynamic message;

//  getter
  UserModel get userModel => _userModel;

  Status get status => _status;

  User get user => _user;

  bool hasStripeId = true;

  // public variables
  List<OrderModel> orders = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async{
        _userModel = await _userServices.getUserById(value.user.uid);
        notifyListeners();
      });
      return true;
    }
    on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      switch (e.code) {
        case "invalid-email":
        case "wrong-password":
        case "user-not-found":
          {
            this.message = "Wrong email address or password.";
            break;
          }
        case "user-disabled":
        case "user-disabled":
          {
            this.message = "This account is disabled";
            break;
          }
        default:
          {
            this.message = "Sign in Failed";
            break;
          }
      }
      notifyListeners();
      return false;
    }
    catch (e) {
      _status = Status.Unauthenticated;
      this.message = "Sign in Failed";
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  void hasCard(){
    hasStripeId = !hasStripeId;
    notifyListeners();
  }

  Future<void> loadCardsAndPurchase({String userId})async{
    cards = await _cardServices.getCards(userId: userId);
    // purchaseHistory = await _purchaseServices.getPurchaseHistory(userId: userId);
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      // User user = FirebaseAuth.instance.currentUser;
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async{
            await user.user.sendEmailVerification();
            print("CREATE USER");
        _userServices.createUser({
          'name': name,
          'email': email,
          'uid': user.user.uid,
          'paystackId': null,
          'stripeId': null,
          'isAdmin': false,
          'isSuperAdmin': false,
        });

            _userModel = await _userServices.getUserById(user.user.uid);
            notifyListeners();

      });
      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      switch (e.code) {
        case "invalid-email":
        case "wrong-password":
        case "user-not-found":
          {
            this.message = "Wrong email address or password.";
            break;
          }
        case "user-disabled":
        case "user-disabled":
          {
            this.message = "This account is disabled";
            break;
          }
        default:
          {
            this.message = "Sign up Failed";
            break;
          }
      }
      notifyListeners();
      return false;
    } catch (e) {
      _status = Status.Unauthenticated;
      this.message = "Sign up Failed";
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }


  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else if (!user.emailVerified) {
      _status = Status.ConfirmEmail;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      _status = Status.Authenticated;
      cards = await _cardServices.getCards(userId: user.uid);
      // purchaseHistory = await _purchaseServices.getPurchaseHistory(userId: user.uid);
      if(_userModel.stripeId == null){
        hasStripeId = false;
        notifyListeners();
      }
      print(_userModel.stripeId);
    }
    notifyListeners();
  }

  Future<bool> addToCart(
      {ProductModel product, String size, int newPrice}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": newPrice == null ? product.price : newPrice,
        "size": size
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  getOrders()async{
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }
}
