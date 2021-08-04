import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/models/review.dart';
import 'package:as_solar_sales/services/product.dart';
import 'package:as_solar_sales/services/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  User user;
  ProductServices _productServices = ProductServices();
  ReviewServices _reviewServices = ReviewServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  List<ReviewModel> reviews = [];
  List<ReviewModel> approvedReviews = [];


  ProductProvider.initialize(){
      loadProducts();
  }

  loadProducts()async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  loadReviews(productId) async {
    reviews = await _reviewServices.getUserReviews(productId: productId);
    approvedReviews = await _reviewServices.getUserApprovedReviews(productId: productId);
    notifyListeners();
  }

  Future search({String productName})async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }

}