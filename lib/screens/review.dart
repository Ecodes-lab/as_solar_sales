import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/order.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ReviewScreen extends StatefulWidget {
  final ProductModel product;

  const ReviewScreen({Key key, this.product}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
          title: CustomText(text: "Reviews"),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        // backgroundColor: white,
        body: MyReview(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRatingAppDialog,
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.green[700],
      ),

    );
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: widget.product.name,
      message: 'Rate this product and tell others what you think.'
          ' Add more description here if you want.',
      image: Image.network(widget.product.picture,
        height: 100,),
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}

class MyReview extends StatelessWidget {
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
          },
        )
    );
  }
}
