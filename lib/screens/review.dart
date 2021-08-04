import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/order.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/services/review.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uuid/uuid.dart';

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
    //
    final productProvider = Provider.of<ProductProvider>(context);
    //
    ReviewServices _reviewServices = ReviewServices();

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
        onPressed: () => _showRatingAppDialog(userProvider, productProvider, _reviewServices),
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.green[700],
      ),

    );
  }

  void _showRatingAppDialog(userProvider, productProvider, _reviewServices) {


    // ReviewServices _reviewServices = ReviewServices();

    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: widget.product.name,
      message: 'Rate this product and tell others what you think.'
          ' Add more description here if you want.',
      image: Image.network(widget.product.picture,
        height: 100,),
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        var uuid = Uuid();
        String id = uuid.v4();
        _reviewServices.createReview(
            userId: userProvider.user.uid,
            id: id,
            productId: widget.product.id,
            productName: widget.product.name,
            productImage: widget.product.picture,
            rating: response.rating,
            comment: response.comment,
            status: "pending",);
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
        // userProvider.reloadUserModel();

        _reviewApprovalDialog();

        await productProvider.loadReviews(widget.product.id);
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  Future<void> _reviewApprovalDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sent'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please note that your comment will be reviewed before it can be approved.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    // ReviewServices _reviewServices = ReviewServices();
    return Container(
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: Colors.black,
      // ),
        alignment: Alignment.center,
        // padding: EdgeInsets.all(10),
        child: appProvider.isLoading
            ? Loading()
            : ListView.builder(
          itemCount: productProvider.reviews.length,
          // shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          // shrinkWrap: true,
          itemBuilder: (_, index){
            // print(productProvider.reviews.length);
            double rating = productProvider.reviews[index].rating.toDouble();
            return Column(
              children: [
                productProvider.reviews[index].status == "approved" ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productProvider.reviews[index].userId == userProvider.user.uid ?
                        Text("${userProvider.userModel.name}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15
                        )),
                        ): Container(),
                        Text("${productProvider.reviews[index].comment}", style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                        )),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: rating,
                          // minRating: 1,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          // onRatingUpdate: (rating) {
                          //   print(rating);
                          // },
                        ),
                        Text("${DateTime.fromMillisecondsSinceEpoch(productProvider.reviews[index].createdAt).toString()}",
                          style: GoogleFonts.lato(textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                          )),
                        ),
                      ],
                    ),
                    // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
                    // trailing: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}",
                    //   style: GoogleFonts.lato(textStyle: TextStyle(
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 13
                    //   )),
                    // ),
                    onTap: (){

                    },
                  ),
                ) : Container(),
                productProvider.reviews[index].status == "pending" && productProvider.reviews[index].userId == userProvider.user.uid ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productProvider.reviews[index].userId == userProvider.user.uid ?
                        Text("${userProvider.userModel.name}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15
                        )),
                        ): Container(),
                        Text("${productProvider.reviews[index].comment}", style: GoogleFonts.lato(textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                        )),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                            rating: rating,
                            // minRating: 1,
                            direction: Axis.horizontal,
                            // allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            // onRatingUpdate: (rating) {
                            //   print(rating);
                            // },
                        ),
                        Text("${DateTime.fromMillisecondsSinceEpoch(productProvider.reviews[index].createdAt).toString()}",
                          style: GoogleFonts.lato(textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                          )),
                        ),
                      ],
                    ),
                    // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
                    trailing: Text("Pending",
                      style: GoogleFonts.lato(textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.red
                      )),
                    ),
                    onTap: (){

                    },
                  ),
                ) : Container(),
              ],
            );
            // OrderModel _order = userProvider.orders[index];
            // return ChangeNotifierProvider.value(value: null);
            // return Column(
            //   children: <Widget>[
            //     ListView.builder(
            //         itemCount: userProvider.orders[index].cart.length,
            //         physics: ClampingScrollPhysics(),
            //         shrinkWrap: true,
            //         itemBuilder: (_, i) {
            //           return ListTile(
            //             // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
            //             title: Text("${userProvider.orders[index].cart[i]["name"]}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
            //                 fontWeight: FontWeight.w400,
            //                 fontSize: 15
            //             )),
            //             ),
            //             subtitle: Text("${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}",
            //               style: GoogleFonts.lato(textStyle: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 12
            //               )),
            //             ),
            //             // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
            //             trailing: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}",
            //               style: GoogleFonts.lato(textStyle: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 13
            //               )),
            //             ),
            //             onTap: (){
            //
            //             },
            //           );
            //         }
            //     )
            //   ],
            // );
          },
        )
    );
  }
}
