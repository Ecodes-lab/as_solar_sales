import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/screens/cart.dart';
import 'package:as_solar_sales/screens/review.dart';
import 'package:as_solar_sales/services/partner.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:as_solar_sales/widgets/loading.dart';
import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';


enum Partners { franchise, ibo, agent }

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _partnerFormKey = GlobalKey();
  TextEditingController partnerController = TextEditingController();
  TextEditingController partnerCodeController = TextEditingController();
  // Partners _partner = Partners.franchise;
  PartnerService _partnerService = PartnerService();
  String _partner = "None";

  String _color = "";
  String _size = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _color = widget.product.colors[0];
    _size = widget.product.size;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
          child: Container(
        color: Colors.white.withOpacity(0.9),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: Loading(),
                )),
                // Center(
                //   child: FadeInImage.memoryNetwork(
                //     placeholder: kTransparentImage,
                //     image: widget.product.picture,
                //     fit: BoxFit.fill,
                //     height: 400,
                //     width: double.infinity,
                //   ),
                // ),
                SizedBox(
                    height: 400.0,
                    width: double.infinity,
                    child: Carousel(
                      // autoplay: false,
                      autoplayDuration: Duration(milliseconds: 5000),
                      defaultImage: Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.product.picture,
                          fit: BoxFit.fill,
                          height: 400,
                          width: double.infinity,
                        ),
                      ),
                      images: widget.product.images != [] ?
                        widget.product.images.map((image) {
                          return Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: image,
                              fit: BoxFit.fill,
                              height: 400,
                              width: double.infinity,
                            ),
                          );
                        }).toList() : null,
                      dotSize: 5.0,
                      dotSpacing: 17.0,
                      dotPosition: DotPosition.bottomCenter,

                      // showIndicator: false,
                      // dotColor: Colors.lightGreenAccent,
                      // dotVerticalPadding: 20.0,
                      indicatorBgPadding: 25.0,
                      dotBgColor: Colors.black.withOpacity(0.6),
                      borderRadius: true,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                    )
                ),

                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Container(
                //       height: 100,
                //       decoration: BoxDecoration(
                //         // Box decoration takes a gradient
                //         gradient: LinearGradient(
                //           // Where the linear gradient begins and ends
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //           // Add one stop for each color. Stops should increase from 0 to 1
                //           colors: [
                //             // Colors are easy thanks to Flutter's Colors class.
                //             Colors.black.withOpacity(0.7),
                //             Colors.black.withOpacity(0.5),
                //             Colors.black.withOpacity(0.07),
                //             Colors.black.withOpacity(0.05),
                //             Colors.black.withOpacity(0.025),
                //           ],
                //         ),
                //       ),
                //       child: Padding(
                //           padding: const EdgeInsets.only(top: 8.0),
                //           child: Container())),
                // ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //       height: 400,
                //       decoration: BoxDecoration(
                //         // Box decoration takes a gradient
                //         gradient: LinearGradient(
                //           // Where the linear gradient begins and ends
                //           begin: Alignment.bottomCenter,
                //           end: Alignment.topCenter,
                //           // Add one stop for each color. Stops should increase from 0 to 1
                //           colors: [
                //             // Colors are easy thanks to Flutter's Colors class.
                //             Colors.black.withOpacity(0.8),
                //             Colors.black.withOpacity(0.6),
                //             Colors.black.withOpacity(0.6),
                //             Colors.black.withOpacity(0.4),
                //             Colors.black.withOpacity(0.07),
                //             Colors.black.withOpacity(0.05),
                //             Colors.black.withOpacity(0.025),
                //           ],
                //         ),
                //       ),
                //       child: Padding(
                //           padding: const EdgeInsets.only(top: 8.0),
                //           child: Container())),
                // ),
                Positioned(
                    bottom: -5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${widget.product.name}'.toUpperCase(),
                              style: GoogleFonts.lato(textStyle: TextStyle(
                                  color: Colors.orange[100],
                                  fontWeight: FontWeight.w600,
                                  // fontSize: 17
                              ),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'NGN ${widget.product.price / 100}',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(textStyle: TextStyle(
                                  color: Colors.orange[100],
                                  fontWeight: FontWeight.w700,
                                  // fontSize: 18
                              ),
                              )

                              // TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 26,
                              //     fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        changeScreen(context, CartScreen());
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 10,
                            color: Colors.green[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_cart, color: Colors.white,),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        changeScreen(context, ReviewScreen(product: widget.product,));
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 10,
                            color: Colors.orange[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Badge(
                                // padding: EdgeInsets.all(8),
                                position: BadgePosition.topEnd(top: -18, end: -10),
                                badgeColor: Colors.green[700],
                                badgeContent: Text('5', style: TextStyle(color: Colors.white),),
                                child: Icon(Icons.comment, color: Colors.white,)
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
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
                                bottomRight: Radius.circular(35))),
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[50],
                          offset: Offset(2, 5),
                          blurRadius: 10)
                    ]),
                child: Column(
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.all(0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8),
                    //         child: CustomText(
                    //           text: "Select a Color",
                    //           color: white,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8),
                    //         child: DropdownButton<String>(
                    //             value: _color,
                    //             style: TextStyle(color: white),
                    //             items: widget.product.colors
                    //                 .map<DropdownMenuItem<String>>(
                    //                     (value) => DropdownMenuItem(
                    //                         value: value,
                    //                         child: CustomText(
                    //                           text: value,
                    //                           color: red,
                    //                         )))
                    //                 .toList(),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 _color = value;
                    //               });
                    //             }),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                            "Size:",
                                            style: GoogleFonts.lato(textStyle: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18
                                            ),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(widget.product.size, style: GoogleFonts.lato(textStyle: TextStyle(
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18
                                        ),
                                        )),
                                        // child: DropdownButton<String>(
                                        //     value: _size,
                                        //     style: TextStyle(color: white),
                                        //     items: widget.product.size
                                        //         .map<DropdownMenuItem<String>>(
                                        //             (value) => DropdownMenuItem(
                                        //                 value: value,
                                        //                 child: CustomText(
                                        //                   text: value,
                                        //                   color: red,
                                        //                 )))
                                        //         .toList(),
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         _size = value;
                                        //       });
                                        //     }),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Description:",
                                    style: GoogleFonts.lato(textStyle: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18
                                      ),
                                    )
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text("${widget.product.description}"[0].toUpperCase() + "${widget.product.description}".substring(1), style: GoogleFonts.lato(textStyle: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17
                                    ),
                                    )),
                                  //   child: Text(
                                  //       widget.product.description,
                                  //         // textAlign: TextAlign.left,
                                  //       style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.green[700],
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              // print(widget.product.franchise);
                              // if (widget.product.franchise == 0 && widget.product.ibo == 0 && widget.product.agent == 0) {

                                appProvider.changeIsLoading();
                                bool success = await userProvider.addToCart(
                                    product: widget.product,
                                    size: _size);
                                if (success) {
                                  _key.currentState.showSnackBar(
                                      SnackBar(content: Text("Added to Cart!",)));
                                  userProvider.reloadUserModel();
                                  appProvider.changeIsLoading();
                                  return;
                                } else {
                                  _key.currentState.showSnackBar(SnackBar(
                                      content: Text("Not added to Cart!")));
                                  appProvider.changeIsLoading();
                                  return;
                                }
                              // } else {
                              //   _partnerAlert(context, userProvider, appProvider);
                              // }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: appProvider.isLoading
                                ? Loading()
                                : Text(
                                    "Add to Cart".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(textStyle: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),
                                    ))

                          )),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future _partnerAlert(BuildContext context, userProvider, appProvider) async {
    // GlobalKey<FormState> _partnerFormKey = GlobalKey();
    // TextEditingController partnerController = TextEditingController();
    // TextEditingController partnerCodeController = TextEditingController();
    // final userProvider = Provider.of<UserProvider>(context);
    // final appProvider = Provider.of<AppProvider>(context);
    setState(() {
      _partner = "None";
      partnerController.text = _partner;
    });
    var alert = new StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {

        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          backgroundColor: Colors.orange,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                    value: _partner,
                      dropdownColor: Colors.black,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _partner = newValue;
                          partnerController.text = newValue;
                        });
                      },
                      items: <String>['None', 'Franchise', 'IBO', 'Agent']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                Form(
                  key: _partnerFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          enabled: false,
                          controller: partnerController,
                          validator: (value){
                            if(value.isEmpty){
                              return 'partner cannot be empty';
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Partner",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                          ),
                        ),
                        Divider(),
                        TextFormField(
                          controller: partnerCodeController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          // validator: (value){
                          //   if(value.isEmpty){
                          //     return 'code cannot be empty';
                          //   }
                          // },
                          decoration: InputDecoration(
                              hintText: "Enter code",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () async {
              if (partnerController.text != null && partnerController.text == "None" && partnerCodeController.text == "") {
                Navigator.pop(context);
                appProvider.changeIsLoading();
                bool success = await userProvider.addToCart(
                    product: widget.product,
                    size: _size);
                if (success) {
                  _key.currentState.showSnackBar(
                      SnackBar(content: Text("Added to Cart!",)));
                  userProvider.reloadUserModel();
                  appProvider.changeIsLoading();
                  return;
                } else {
                  _key.currentState.showSnackBar(SnackBar(
                      content: Text("Not added to Cart!")));
                  appProvider.changeIsLoading();
                  return;
                }
                // dynamic partner = await _partnerService.getPartner();
                // dynamic partner = await _partnerService.getPartner(partnerController.text);

                // partner.m
                // print(partner);
              }
              if(partnerController.text != null && partnerController.text != "None" && partnerCodeController.text != null){
                await _partnerService.getPartner(partnerController.text).then((value) {
                  value.map((e) async {
                    Map partners = {
                      "Franchise": widget.product.franchise,
                      "IBO": widget.product.ibo,
                      "Agent": widget.product.agent
                    };
                    if (e.get("partner") == partnerController.text && e.get("code") == partnerCodeController.text) {
                      // print(e.data()["partner"]);
                      appProvider.changeIsLoading();
                      bool success = await userProvider.addToCart(
                          product: widget.product,
                          size: _size,
                          newPrice: partners[partnerController.text]
                        );
                      if (success) {
                        _key.currentState.showSnackBar(
                            SnackBar(content: Text("Added to Cart!")));
                        userProvider.reloadUserModel();
                        appProvider.changeIsLoading();
                        return;
                      } else {
                        _key.currentState.showSnackBar(SnackBar(
                            content: Text("Not added to Cart!")));
                        appProvider.changeIsLoading();
                        return;
                      }
                    } else {
                      // print("Code is incorrect for partner ${partnerController.text}");
                      _key.currentState.showSnackBar(SnackBar(content: Text("Code is incorrect for partner ${partnerController.text}"), duration: Duration(milliseconds: 5000),));
                      return;
                    }
                    // return;
                  }).toList();
                });
                // dynamic partner = await _partnerService.getPartner();
                // dynamic partner = await _partnerService.getPartner(partnerController.text);

                // partner.m
                // print(partner);
                partnerController.clear();
                partnerCodeController.clear();
              }
              // else {
              //   Navigator.pop(context);
              //   appProvider.changeIsLoading();
              //   bool success = await userProvider.addToCart(
              //       product: widget.product,
              //       size: _size);
              //   if (success) {
              //     _key.currentState.showSnackBar(
              //         SnackBar(content: Text("Added to Cart!",), duration: Duration(milliseconds: 5000)));
              //     userProvider.reloadUserModel();
              //     appProvider.changeIsLoading();
              //     return;
              //   } else {
              //     _key.currentState.showSnackBar(SnackBar(
              //         content: Text("Not added to Cart!"), duration: Duration(milliseconds: 5000)));
              //     appProvider.changeIsLoading();
              //     return;
              //   }
              //   // dynamic partner = await _partnerService.getPartner();
              //   // dynamic partner = await _partnerService.getPartner(partnerController.text);
              //
              //   // partner.m
              //   // print(partner);
              //   partnerController.clear();
              //   partnerCodeController.clear();
              // }
              // Fluttertoast.showToast(msg: 'Partner added');
              Navigator.pop(context);
            }, child: Text(
                'ADD',
                style: GoogleFonts.lato(textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    // fontSize: 18
                ))
            )),
            FlatButton(onPressed: (){
              partnerController.clear();
              partnerCodeController.clear();
              Navigator.pop(context);
            }, child: Text(
                'CANCEL',
                style: GoogleFonts.lato(textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    // fontSize: 18
                ))
            )),

          ],
        );
      }
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
