import 'package:as_solar_sales/screens/confirm_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:as_solar_sales/provider/app.dart';
import 'package:as_solar_sales/provider/product.dart';
import 'package:as_solar_sales/provider/user.dart';
import 'package:as_solar_sales/screens/home.dart';
import 'package:as_solar_sales/screens/login.dart';
import 'package:as_solar_sales/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'helpers/style.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.blueAccent,
  //   ),
  // );
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductProvider.initialize()),
    ChangeNotifierProvider.value(value: AppProvider()),
  ],
    child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.white
    ),
    home: SplashScreenWidget(),
  ),));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      case Status.ConfirmEmail:
        return ConfirmEmail();
      default: return Login();
    }
  }
}


class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      photoSize: 200.0,
      // useLoader: false,

      loaderColor: primaryColor,
      gradientBackground: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.centerLeft,
        colors: [Colors.deepOrange[600], Colors.deepOrange[300]],
        tileMode: TileMode.clamp,
      ),
      navigateAfterSeconds: new ScreensController(),
      backgroundColor: primaryColor,
      image: Image.asset('images/splash_screen_logo.png', fit: BoxFit.fill, width: 1533.0,),
    );
  }
}





