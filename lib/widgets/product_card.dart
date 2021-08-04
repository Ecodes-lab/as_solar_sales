import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/screens/product_details.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'loading.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          await productProvider.loadReviews(product.id);
          changeScreen(context, ProductDetails(product: product,));
        },
        child: Container(
          decoration: BoxDecoration(
              color: white,
              // color: Colors.green[800],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    // color: Colors.grey[300],
                    color: red.withOpacity(0.2),
                    // offset: Offset(-2, -1),
                    offset: Offset(3, 2),
                    blurRadius: 5),
              ]),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.center,
                        child: Loading(),
                      )),
                      Center(
                        // child: Image.network(product.picture),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: product.picture,
                          fit: BoxFit.cover,
                          height: 140,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${product.name} \n'.toUpperCase(),
                    style: GoogleFonts.lato(textStyle: TextStyle(color: black, fontWeight: FontWeight.w700)),
                  ),
                  TextSpan(
                    text: 'by: ${product.brand} \n\n\n\n',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextSpan(
                    text: 'NGN ${product.price / 100} \t',
                    style: GoogleFonts.lato(textStyle: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w700,
                          // fontSize: 15
                      )),
                    // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: product.sale ? 'ON SALE ' : "",

                    style: GoogleFonts.lato(textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        // fontSize: 15,
                        color: Colors.orange[700]
                    )),
                    // TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w400,
                    //     color: Colors.red),
                  ),
                ], style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _productImage(String picture) {
    if (picture == null) {
      return Container(
        child: CustomText(text: "No Image"),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            product.picture,
            height: 140,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
