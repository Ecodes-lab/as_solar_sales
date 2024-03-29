
import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/screens/product_video.dart';
import 'package:as_solar_sales/screens/products.dart';
import 'package:as_solar_sales/widgets/loading.dart';
// import 'package:as_solar_sales/provider/app.dart';
// import 'package:as_solar_sales/provider/product.dart';
// import 'package:as_solar_sales/provider/user.dart';
// import 'package:as_solar_sales/screens/category.dart';
// import 'package:as_solar_sales/screens/product_search.dart';
// import 'package:as_solar_sales/screens/test_credit_card.dart';
// import 'package:as_solar_sales/services/product.dart';
// import 'package:as_solar_sales/services/stripe.dart';
// import 'package:as_solar_sales/widgets/custom_text.dart';
// import 'package:as_solar_sales/widgets/featured_products.dart';
// import 'package:as_solar_sales/widgets/product_card.dart';
// import 'package:as_solar_sales/widgets/search.dart';
// import 'package:provider/provider.dart';
//
// import '../main.dart';
// import 'cart.dart';
// import 'manage_cards.dart';
// import 'order.dart';
// import 'credit_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  changeScreen(context, ProductPage());
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.green[800],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // color: Colors.grey[300],
                            color: Colors.black.withOpacity(0.2),
                            // offset: Offset(-2, -1),
                            offset: Offset(3, 2),
                            blurRadius: 5),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("AS Products",
                          style: GoogleFonts.lato(textStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                          )
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  changeScreen(context, ProductVideoScreen());
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.green[800],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // color: Colors.grey[300],
                            color: Colors.black.withOpacity(0.2),
                            // offset: Offset(-2, -1),
                            offset: Offset(3, 2),
                            blurRadius: 5),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("AS Video",
                          style: GoogleFonts.lato(textStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                          )
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userProvider.signOut();
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}


// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
//
// class _HomePageState extends State<HomePage> {
//   final _key = GlobalKey<ScaffoldState>();
//   StripeServices stripe = StripeServices();
//   ProductServices _productServices = ProductServices();
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//     _refreshAction() {
//       setState(() {
//         productProvider.loadProducts();
//       });
//     }
//     return Scaffold(
//       key: _key,
//       backgroundColor: white,
//       endDrawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(color: Colors.green[900]),
//               accountName: Text(
//                 "${userProvider.userModel?.name}".toUpperCase() ?? "username lading...",
//                 style: GoogleFonts.lato(textStyle: TextStyle(
//                   color: white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17
//                 )),
//                 // color: white,
//                 // weight: FontWeight.bold,
//                 // size: 18,
//               ),
//               accountEmail: Text(
//                 userProvider.userModel?.email ?? "email loading...",
//                 style: GoogleFonts.lato(textStyle: TextStyle(
//                     color: white,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15
//                 )),
//               ),
//             ),
//             ListTile(
//               onTap: () async{
//                 await userProvider.getOrders();
//                 changeScreen(context, OrdersScreen());
//               },
//               leading: Icon(Icons.bookmark_border),
//               title: Text(
//                 "ORDERS",
//                 style: GoogleFonts.lato(textStyle: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 17
//                 )),
//               ),
//             ),
//             ListTile(
//               onTap: () async{
//                 await userProvider.getOrders();
//                 changeScreen(context, CategoryScreen());
//               },
//               leading: Icon(Icons.lightbulb_outline),
//               title: Text(
//                 "CATEGORY",
//                 style: GoogleFonts.lato(textStyle: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 17
//                 )),
//               ),
//             ),
//
//             // ListTile(
//             //   leading: Icon(Icons.add),
//             //   title: CustomText(
//             //     text: "Add Credit Card",
//             //   ),
//             //   onTap: () {
//             //     changeScreen(context, CreditCard(title: "Add card",));
//             //   },
//             // ),
//             //
//             // ListTile(
//             //   leading: Icon(Icons.credit_card),
//             //   title: CustomText(
//             //     text: "Manage Cards",
//             //   ),
//             //   onTap: () {
//             //     changeScreen(context, ManagaCardsScreen());
//             //   },
//             // ),
//             //
//             //
//             // ListTile(
//             //   leading: Icon(Icons.add),
//             //   title: CustomText(
//             //     text: "Test Credit Card",
//             //   ),
//             //   onTap: () {
//             //     changeScreen(context, PaystackPage());
//             //   },
//             // ),
//
//
//             // ListTile(
//             //   leading: Icon(Icons.history),
//             //   title: CustomText(
//             //     text: "Purchase history",
//             //   ),
//             //   onTap: () {
//             //     changeScreen(context, OrdersScreen());
//             //   },
//             // ),
//
//             // ListTile(
//             //   leading: Icon(Icons.memory),
//             //   title: CustomText(
//             //     text: "Subscriptions",
//             //   ),
//             //   onTap: () {
//             //     changeScreen(context, ManagaCardsScreen());
//             //   },
//             // ),
//
//             ListTile(
//               onTap: () {
//                userProvider.signOut();
//               },
//               leading: Icon(Icons.exit_to_app),
//               title: Text(
//                 "LOGOUT",
//                 style: GoogleFonts.lato(textStyle: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 17
//                 )),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: <Widget>[
// //           Custom App bar
//             Stack(
//               children: <Widget>[
//                 Positioned(
//                   top: 10,
//                   right: 20,
//                   child: Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                           onTap: () {
//                             _key.currentState.openEndDrawer();
//                           },
//                           child: Icon(Icons.menu, color: Colors.green[700],))),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 60,
//                   child: Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                           onTap: (){
//                             changeScreen(context, CartScreen());
//                           },
//                           child: Icon(Icons.shopping_cart, color: Colors.green[700],))),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 100,
//                   child: Align(
//                       alignment: Alignment.topRight, child: GestureDetector(
//                       onTap: (){
//                         _key.currentState.showSnackBar(SnackBar(
//                             content: Text("User profile")));
//                       },
//                       child: Icon(Icons.person, color: Colors.green[700],))),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'What are\nyou Shopping for?',
//                     style: GoogleFonts.lato(textStyle: TextStyle(
//                         fontSize: 30,
//                         color: Colors.black.withOpacity(0.6),
//                         fontWeight: FontWeight.w400),
//                     )
//                   ),
//                 ),
//               ],
//             ),
//
// //          Search Text field
// //            Search(),
//
//             Container(
//               decoration: BoxDecoration(
//                   color: white,
//                   borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(20))),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 8, left: 8, right: 8, bottom: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: grey.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.search,
//                       color: Colors.green,
//                     ),
//                     title: TextField(
//                       textInputAction: TextInputAction.search,
//                       onSubmitted: (pattern)async{
//                         await productProvider.search(productName: pattern);
//                         changeScreen(context, ProductSearchScreen());
//                       },
//                       decoration: InputDecoration(
//                         hintText: "panel, inverter...",
//                         border: InputBorder.none,
//                         hintStyle: GoogleFonts.lato(textStyle: TextStyle(
//                             fontSize: 17,
//                             // color: Colors.black.withOpacity(0.6),
//                             fontWeight: FontWeight.w400),
//                         )
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
// //            featured products
//             Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Container(
//                       alignment: Alignment.centerLeft,
//                       child: new Text('Featured products', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),)),
//                 ),
//               ],
//             ),
//             FeaturedProducts(),
//
// //          recent products
//             Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Container(
//                       alignment: Alignment.centerLeft,
//                       child: new Text('Recent products', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)))),
//                 ),
//               ],
//             ),
//
//             Column(
//               children: productProvider.products
//                   .map((item) => GestureDetector(
//                         child: ProductCard(
//                           product: item,
//                         ),
//                       ))
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _refreshAction,
//         child: Icon(Icons.refresh),
//         backgroundColor: Colors.green[700],
//       ),
//     );
//   }
// }
