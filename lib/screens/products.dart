import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/screens/category.dart';
import 'package:as_solar_sales/screens/product_search.dart';
import 'package:as_solar_sales/screens/test_credit_card.dart';
import 'package:as_solar_sales/services/product.dart';
import 'package:as_solar_sales/services/stripe.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:as_solar_sales/widgets/featured_products.dart';
import 'package:as_solar_sales/widgets/product_card.dart';
import 'package:as_solar_sales/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'cart.dart';
import 'manage_cards.dart';
import 'order.dart';
import 'credit_card.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  final _key = GlobalKey<ScaffoldState>();
  StripeServices stripe = StripeServices();
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    _refreshAction() {
      setState(() {
        productProvider.loadProducts();
      });
    }
    return Scaffold(
      key: _key,
      backgroundColor: white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green[900]),
              accountName: Text(
                "${userProvider.userModel?.name}".toUpperCase() ?? "username lading...",
                style: GoogleFonts.lato(textStyle: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17
                )),
                // color: white,
                // weight: FontWeight.bold,
                // size: 18,
              ),
              accountEmail: Text(
                userProvider.userModel?.email ?? "email loading...",
                style: GoogleFonts.lato(textStyle: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                )),
              ),
            ),
            ListTile(
              onTap: () async{
                await userProvider.getOrders();
                changeScreen(context, OrdersScreen());
              },
              leading: Icon(Icons.bookmark_border),
              title: Text(
                "ORDERS",
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17
                )),
              ),
            ),
            ListTile(
              onTap: () async{
                await userProvider.getOrders();
                changeScreen(context, CategoryScreen());
              },
              leading: Icon(Icons.lightbulb_outline),
              title: Text(
                "CATEGORY",
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17
                )),
              ),
            ),

            // ListTile(
            //   leading: Icon(Icons.add),
            //   title: CustomText(
            //     text: "Add Credit Card",
            //   ),
            //   onTap: () {
            //     changeScreen(context, CreditCard(title: "Add card",));
            //   },
            // ),
            //
            // ListTile(
            //   leading: Icon(Icons.credit_card),
            //   title: CustomText(
            //     text: "Manage Cards",
            //   ),
            //   onTap: () {
            //     changeScreen(context, ManagaCardsScreen());
            //   },
            // ),
            //
            //
            // ListTile(
            //   leading: Icon(Icons.add),
            //   title: CustomText(
            //     text: "Test Credit Card",
            //   ),
            //   onTap: () {
            //     changeScreen(context, PaystackPage());
            //   },
            // ),


            // ListTile(
            //   leading: Icon(Icons.history),
            //   title: CustomText(
            //     text: "Purchase history",
            //   ),
            //   onTap: () {
            //     changeScreen(context, OrdersScreen());
            //   },
            // ),

            // ListTile(
            //   leading: Icon(Icons.memory),
            //   title: CustomText(
            //     text: "Subscriptions",
            //   ),
            //   onTap: () {
            //     changeScreen(context, ManagaCardsScreen());
            //   },
            // ),

            ListTile(
              onTap: () {
                userProvider.signOut();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "LOGOUT",
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17
                )),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar
            Stack(
              children: <Widget>[

                Positioned(
                  top: 10,
                  right: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState.openEndDrawer();
                          },
                          child: Icon(Icons.menu, color: Colors.green[700],))),
                ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: (){
                            changeScreen(context, CartScreen());
                          },
                          child: Icon(Icons.shopping_cart, color: Colors.green[700],))),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                      alignment: Alignment.topRight, child: GestureDetector(
                      onTap: (){
                        _key.currentState.showSnackBar(SnackBar(
                            content: Text("User profile")));
                      },
                      child: Icon(Icons.person, color: Colors.green[700],))),
                ),
                // Container(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
                  child: Text(
                      'What are\nyou Shopping for?',
                      style: GoogleFonts.lato(textStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w400),
                      )
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        // print("CLICKED");
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(35))
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 15, 0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //       'What are\nyou Shopping for?',
            //       style: GoogleFonts.lato(textStyle: TextStyle(
            //           fontSize: 30,
            //           color: Colors.black.withOpacity(0.6),
            //           fontWeight: FontWeight.w400),
            //       )
            //   ),
            // ),
//          Search Text field
//            Search(),

            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern)async{
                        await productProvider.search(productName: pattern);
                        changeScreen(context, ProductSearchScreen());
                      },
                      decoration: InputDecoration(
                          hintText: "panel, inverter...",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.lato(textStyle: TextStyle(
                              fontSize: 17,
                              // color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400),
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),

//            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Featured products', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),)),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Recent products', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)))),
                ),
              ],
            ),

            Column(
              children: productProvider.products
                  .map((item) => GestureDetector(
                child: ProductCard(
                  product: item,
                ),
              ))
                  .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshAction,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
//Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//GestureDetector(
//onTap: (){
//key.currentState.openDrawer();
//},
//child: Icon(Icons.menu))
//],
//),
