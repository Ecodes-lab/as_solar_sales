import 'package:as_solar_sales/helpers/common.dart';
import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/models/product.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/screens/product_details.dart';
import 'package:as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FeaturedCard extends StatelessWidget {
  final ProductModel product;

  const FeaturedCard({Key key, this.product}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () async {
          await productProvider.loadReviews(product.id);
          changeScreen(context, ProductDetails(product: product,));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                Color.fromARGB(62, 168, 174, 201),
                offset: Offset(0, 9),
                blurRadius: 14,
              ),
            ],
          ),
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
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: product.picture,
                    fit: BoxFit.cover,
                    height: 220,
                    width: 200,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),

                            // Colors.green.withOpacity(0.8),
                            // Colors.green.withOpacity(0.7),
                            // Colors.green.withOpacity(0.6),
                            // Colors.green.withOpacity(0.6),
                            // Colors.green.withOpacity(0.4),
                            // Colors.green.withOpacity(0.1),
                            // Colors.green.withOpacity(0.05),
                            // Colors.green.withOpacity(0.025),
                          ],
                        ),
                      ),

                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container()
                      )),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${product.name} \n'.toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.orange[400], fontWeight: FontWeight.w700))),
                        // TextSpan(text: '\₦${product.price / 100} \n', style:
                        TextSpan(text: 'NGN ${product.price / 100} \n', style:
                        GoogleFonts.lato(textStyle: TextStyle(
                            color: Colors.orange[100],
                            fontWeight: FontWeight.w700,
                            // fontSize: 15
                        )),
                          // TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),

                      ]))
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
