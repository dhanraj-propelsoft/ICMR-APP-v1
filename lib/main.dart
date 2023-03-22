import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wapindex/LoginScreen.dart';
import 'package:wapindex/homeScreen.dart';
import 'package:wapindex/utils/ColorUtils.dart';
import 'package:wapindex/utils/DimensionUtils.dart';
import 'package:wapindex/utils/Methods.dart';
import 'package:wapindex/utils/PreferenceUtils.dart';
import 'package:wapindex/utils/StringResource.dart';
import 'package:wapindex/utils/StyleUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MaterialApp(
    theme: new ThemeData(
        primaryColor: ColorUtils.primary,
        primaryColorDark: ColorUtils.primary,
        accentColor: ColorUtils.primary,

//        // Define the default font family.
//        fontFamily: 'Ageo',
//
//        // Define the default TextTheme. Use this to specify the default
//        // text styling for headlines, titles, bodies of text, and more.
//        textTheme: TextTheme(
//          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color: Colors.white),
//          body1: TextStyle(fontSize: 14.0, fontFamily: 'Ageo'),
//
//        ),
//
//        primaryTextTheme: TextTheme(
//            title: TextStyle(
//                color: Colors.white
//            )
//        ),

        primaryIconTheme: IconThemeData(color: Colors.white)),
    home: new SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isLogin = prefs.getBool(PreferenceUtils.PREF_LOGIN_STATUS);
    if (isLogin != null && isLogin) {
      pushNextReplacmentScreen(context, homeScreen());
    } else {
      pushNextReplacmentScreen(context, LoginScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  ColorUtils.primary,
                  ColorUtils.app_green,
//                  ColorUtils.primary,
//                  ColorUtils.app_green,
                ],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 0.4],
                tileMode: TileMode.clamp),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                maxRadius: DimensionUtils.img_size_splash_circle_radius,
                backgroundColor: ColorUtils.logo_color,
                child: ClipRRect(
                    child: Image.asset(
                  'assets/images/logo_icon.png',
                  width: DimensionUtils.img_size_splash,
                  height: DimensionUtils.img_size_splash,
                )),
              ),
              SizedBox(
                height: DimensionUtils.margin_large,
              ),
              Text(app_title,
                  style: styleAppName.copyWith(
                      color: ColorUtils.black,
                      fontSize: DimensionUtils.txt_size_splash)),

//                  Image.asset('assets/images/logo_icon.png',width: DimensionUtils.img_size_splash,height: DimensionUtils.img_size_splash,),
            ],
          ))),
    );
  }
}
