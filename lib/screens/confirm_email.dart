import 'package:as_solar_sales/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfirmEmail extends StatelessWidget {
  const ConfirmEmail({Key key}) : super(key: key);
  static String id = 'confirm-email';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: Center(
                child: Text(
                  'An email has just been sent to you, Click the link provided to complete registration',
                  style: GoogleFonts.lato(textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      // letterSpacing: 0.5,
                      fontWeight: FontWeight.w400),
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          userProvider.signOut();
        },
        child: Text("LOGIN", style: GoogleFonts.lato(textStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w700),
        )),
        backgroundColor: Colors.deepOrange,

      ),
    );
  }
}