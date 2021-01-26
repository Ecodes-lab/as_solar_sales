import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/order.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     iconTheme: IconThemeData(color: black),
    //     backgroundColor: white,
    //     elevation: 0.0,
    //     title: CustomText(text: "Orders"),
    //     leading: IconButton(
    //         icon: Icon(Icons.close),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         }),
    //   ),
    //   backgroundColor: white,
    //   body: ListView.builder(
    //       itemCount: userProvider.orders.length,
    //       itemBuilder: (_, index){
    //         OrderModel _order = userProvider.orders[index];
    //         return ListTile(
    //           leading: CustomText(
    //             text: "\$${_order.total / 100}",
    //             weight: FontWeight.bold,
    //           ),
    //           title: Text(_order.description),
    //           subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
    //           trailing: CustomText(text: _order.status, color: green,),
    //         );
    //       }),
    // );
    return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          // title: Text(
          //   "Purchase History",
          //   style: TextStyle(color: Colors.black),
          //
          title: CustomText(text: "Orders"),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        // backgroundColor: white,
        body: MyOrder()

        // ListView.builder(
        //   itemCount: userProvider.orders.length,
        //   itemBuilder: (_, index){
        //
        //     OrderModel _order = userProvider.orders[index];
        //     _order.cart.map((e) {
        //       // print(e['price']);
        //       // return Text("${e['price']}");
        //       return ListTile(
        //         leading: CustomText(text: "${e["price"]}"),
        //         title: Text(e["name"]),
        //         subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
        //         trailing: Icon(Icons.more_horiz),
        //         // onTap: (){
        //         //
        //         // },
        //       );
        //
        //     }).toList();
        //     return;
        //   },
        //   // separatorBuilder: (BuildContext context, int index) {
        //   //   return Divider();
        //   // },
        // )
    );
  }
}

class MyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: Colors.black,
      // ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: userProvider.orders.length,
        // shrinkWrap: true,
        itemBuilder: (_, index){

          // OrderModel _order = userProvider.orders[index];
          // return ChangeNotifierProvider.value(value: null);
          return Column(
            children: <Widget>[
              ListView.builder(
                itemCount: userProvider.orders[index].cart.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, i) {
                    return ListTile(
                      // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
                      title: Text("${userProvider.orders[index].cart[i]["name"]}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                        )),
                      ),
                      subtitle: Text("${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}",
                        style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        )),
                      ),
                      // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
                      trailing: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}",
                        style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13
                        )),
                      ),
                      onTap: (){

                      },
                    );
                  }
              )
            ],
          );
          // _order.cart.map((e) {
          //   // print(e['price']);
          //   // return Text("${e['price']}");
          //   return ListTile(
          //     leading: CustomText(text: "${e["price"]}"),
          //     title: Text(e["name"]),
          //     subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
          //     trailing: Icon(Icons.more_horiz),
          //     // onTap: (){
          //     //
          //     // },
          //   );
          //
          // }).toList();
          // return;
        },
        // separatorBuilder: (BuildContext context, int index) {
        //   return Divider();
        // },
      )
    );
  }
}
