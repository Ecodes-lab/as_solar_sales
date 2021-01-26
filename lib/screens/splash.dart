import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/main.dart';
import 'package:as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
// import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Loading(),
            ],
          ),
        ],
      ),
    );
  }
}

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new SplashScreen(
//       seconds: 14,
//       photoSize: 200.0,
//       loaderColor: primaryDarkColor,
//       gradientBackground: LinearGradient(
//         begin: Alignment.bottomLeft,
//         end: Alignment.centerLeft,
//         colors: [Colors.black87, Colors.yellow],
//         tileMode: TileMode.clamp,
//       ),
//       navigateAfterSeconds: new ScreensController(),
//       backgroundColor: primaryColor,
//       image: Image.asset('images/splash_screen.png'),
//     );
//   }
// }


// class Splash extends StatefulWidget {
//   @override
//   _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
// }
//
// class _SplashScreenWidgetState extends State<Splash> {
//   @override
//   Widget build(BuildContext context) {
//     return new SplashScreen(
//       seconds: 14,
//       photoSize: 200.0,
//       loaderColor: primaryDarkColor,
//       gradientBackground: LinearGradient(
//         begin: Alignment.bottomLeft,
//         end: Alignment.centerLeft,
//         colors: [Colors.black87, Colors.yellow],
//         tileMode: TileMode.clamp,
//       ),
//       navigateAfterSeconds: new ScreensController(),
//       backgroundColor: primaryColor,
//       image: Image.asset('images/splash_screen.png'),
//     );
//   }
// }