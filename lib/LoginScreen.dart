//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wapindex/forgot_password.dart';
import 'package:wapindex/homeScreen.dart';
import 'package:wapindex/utils/APIUtils.dart';
import 'package:wapindex/utils/ColorUtils.dart';
import 'package:wapindex/utils/CommonUtils.dart';
import 'package:wapindex/utils/Methods.dart';
import 'package:wapindex/utils/PreferenceUtils.dart';
import 'package:wapindex/utils/StringResource.dart';
import 'package:wapindex/utils/StyleUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:wapindex/widgets/gif_progress_widget.dart';
import 'package:wapindex/widgets/submitandcontinuebutton.dart';
import 'dart:convert';

import 'models/LoginResponseData.dart';
import 'utils/DimensionUtils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  bool isMobile = true;
  bool isPassword = true;
  bool _obscureText = true;
  String strMobileError="Enter user name";
  bool? isRememberMe=false;

//  late ProgressDialog pr;
  bool isFirst=true;
  late SharedPreferences prefs;

  bool logoutUser = false;
  bool isProgress = false;

  initData() async {

    prefs = await SharedPreferences.getInstance();
    bool? isLogin=prefs.getBool(PreferenceUtils.PREF_LOGIN_STATUS);
    bool? isRememberMe=prefs.getBool(PreferenceUtils.PREF_REMEMBER_ME);

//    setState(() {
//      mobileController.text="test@gmail.com";
//      passwordController.text="1234";
//    });

//    pr = CommonUtils.getProgressDialog(context);

    if(isLogin!=null&&isLogin) {
      if(isRememberMe!=null&&isRememberMe){
        pushNextReplacmentScreen(context, homeScreen());
      }
    }

  }







//  startTime() async {
//    var _duration = new Duration(seconds: 2);
//    return new Timer(_duration, navigationPage);
//  }

  void navigationPage() async{
    pushNextReplacmentScreen(context, homeScreen());
  }

  void login(){
    var mobileNumber=mobileController.text.trim();
    var password=passwordController.text.trim();

    if(mobileNumber.length>0&&password.length>0){
//      startTime();
      loginRequest(mobileNumber, password);
//        showToast(mobileController.text+" "+passwordController.text);
    }else{
      if(mobileNumber.length==0){
        isMobile=false;
        strMobileError="Enter user name";
        setState(() {});
      }
      if(password.length==0){
        isPassword=false;
        setState(() {});
      }
    }

  }
  final logger = Logger();

  void showProgress(){
    setState(() {
      isProgress=true;
    });
  }

  void hideProgress(){
    setState(() {
      isProgress=false;
    });
  }


  void loginRequest(String email,String password) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("loginRequest.................1");
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };
      debugPrint("loginRequest.................2"+data.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_LOGIN, data,null,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        LoginResponseData responseData=LoginResponseData.fromJson(response.data);

        if(responseData.success==true){
//          PreferenceUtils.saveBoolean(prefs,PreferenceUtils.PREF_LOGIN_STATUS, true);
          PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_AUTH_TOKEN, responseData.data!.token!);
          PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_USERNAME, responseData.data!.profile!.name!);
          PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_MOBILE, responseData.data!.profile!.mobileNo!);
          navigationPage();
        }else{
          CommonUtils.showErrorToast(context, responseData.message);
        }

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }




//    Dio dio = new Dio();
//    var formdata = FormData.fromMap({
//      "mobile1": email,
//      "password": password,
//    });
//
//    ProgressDialog pd = ProgressDialog(context: context);
//    pd.show(max: 100, msg: "Please wait...");
//    try {
//      var response = await dio.post(APIUtils.BASE_URL+APIUtils.API_LOGIN, data: formdata);
//      pd.close();
//      logger.d("Response Code : "+response.statusCode.toString());
//      if (response.statusCode == 200) {
//        // If the server did return a 201 CREATED response,
//        // then parse the JSON.
//        logger.d("Response Data : "+response.data.toString());
//        LoginResponseData loginResponse=LoginResponseData.fromJson(response.data);
//        if(loginResponse.success!){
//
//          PreferenceUtils.saveBoolean(prefs,PreferenceUtils.PREF_LOGIN_STATUS, true);
//          PreferenceUtils.saveBoolean(prefs,PreferenceUtils.PREF_REMEMBER_ME, isRememberMe!);
//
//          PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_USERID, email);
//          if(loginResponse.data!.name!=null){
//            PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_USERNAME, loginResponse.data!.name!);
//          }
//
//          PreferenceUtils.saveString(prefs,PreferenceUtils.PREF_AUTH_TOKEN, loginResponse.data!.token!);
//          navigationPage();
////          startTime();
//
//        }else{
//          if(loginResponse.message!=null&&loginResponse.message!.length>0){
//            CommonUtils.showErrorToast(loginResponse.message);
//          }else{
//            CommonUtils.showErrorToast(CommonUtils.COMMON_FAILED);
//          }
//
//        }
////    return LoginResponseData.fromJson(json.decode(response.body));
//      } else {
//        // If the server did not return a 201 CREATED response,
//        // then throw an exception.
//        CommonUtils.showRequestErrorToast(response.statusCode!, response.data);
////    throw Exception('Failed to load album');
//      }
//    }on DioError catch (e) {
//      print(e);
//      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//        content: Text("Error occured."),
//      ));
//
//      pd.close();
//    }

  }

  @override
  Widget build(BuildContext context) {

    if(isFirst){
      isFirst=false;
      initData();
    }

    final emailField = TextField(
      onChanged: (value){
        isMobile = true;
        setState(() {});
      },
      controller: mobileController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: edgeInsets,
          labelText: "User Name",
          errorText: isMobile?null:strMobileError,
          border: outlineInputBorder),
    );


    final passwordField = TextField(
      onChanged: (value){
        isPassword = true;
        setState(() {});
      },
      controller: passwordController,
      obscureText: _obscureText,
      style: style,
      decoration: InputDecoration(
          contentPadding: edgeInsets,
          labelText: "Password",
          errorText: isPassword?null:"Enter password",
          suffixIcon: GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscureText ? 'show password' : 'hide password',
              color: ColorUtils.grey_form,
            ),
          ),
          border:outlineInputBorder),
    );

    final loginButon =SubmitAndContinueButton(onTab: (){
      login();
    }, text: "Submit", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green);

//    final loginButon =Material(color: Colors.transparent,child:InkWell(
//
//      onTap: () {
//        login();
////        startTime();
//      },
//      child: Ink(
//        width: 200,
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(DimensionUtils.margin_xxlarge),
//            color: ColorUtils.primary),
//        child: Padding(
//          padding:  EdgeInsets.all(DimensionUtils.margin_xlarge),
//          child:Text("Login",
//              textAlign: TextAlign.center,
//              style: buttonStyle.copyWith(
//                  color: Colors.black, fontWeight: FontWeight.bold)),
//        ),
//      ),
//    ));




    final buttonForgotPassword=  GestureDetector(
      onTap: () {
        //Integrate Forgot Password
//        pushNextScreen(context, ForgotPasswordScreen());
      },
      child:Align(
        alignment: Alignment.centerLeft,
        child: Container(
          child: Text("Forgot Password ?",textAlign: TextAlign.left,style: style.copyWith(
            decoration: TextDecoration.underline,
          ),),
        ),
      ),
    );

//    final rememberMeRow=  Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Checkbox(
//          value: isRememberMe,
//          onChanged: (bool? value) {
//            setState(() {
//              isRememberMe = value;
//            });
//          },
//        ),
////        SizedBox(
////          width: DimensionUtils.margin_small,
////        ),
//        Text(
//          'Remember Me',
//          style: style.copyWith(color: ColorUtils.primary),
//        ), //Checkbox
//      ], //<Widget>[]
//    );
    var size =MediaQuery.of(context).size.height / 100;
    var topSize=size*50;
    var bottomSize=size*50;

    return GifProgressWidget(
      progress:  isProgress,
      child: Scaffold(
        body: Container(
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
                  tileMode: TileMode.clamp
              ),
            ),
          child: SingleChildScrollView(
              child:
           Center(

            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                Container(
                  height: topSize,
                  child:Column(children: <Widget>[
                    SizedBox(height: DimensionUtils.margin_xxxxlarge),
                    CircleAvatar(
                      maxRadius: DimensionUtils.img_size_splash_circle_radius,
                      backgroundColor: ColorUtils.logo_color,
                      child: ClipRRect(
                          child: Image.asset('assets/images/logo_icon.png',width: DimensionUtils.img_size_splash,height: DimensionUtils.img_size_splash,)),
                    ),
//                  Image.asset('assets/images/logo_icon.png',width: DimensionUtils.img_size_login_logo,height: DimensionUtils.img_size_login_logo),
                    SizedBox(height: DimensionUtils.margin_xlarge),
                    Text(app_title,style: styleAppName.copyWith(color: ColorUtils.black,fontSize: DimensionUtils.txt_size_splash)),
                    SizedBox(height: DimensionUtils.margin_xlarge),
                  ],)
              ),
//            ClipRRect(
//
//              borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0)),


                 Container(
                   height: bottomSize,
                   child:Padding(
                     padding: EdgeInsets.all(DimensionUtils.margin_xlarge),
                     child: Container(

                        decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.only(topRight:Radius.circular(DimensionUtils.margin_xxlarge),topLeft:Radius.circular(DimensionUtils.margin_xxlarge)),
                        ),
//                     depth: -15,
//                     customBorderRadius: BorderRadius.only(topRight:Radius.circular(DimensionUtils.margin_xxlarge),topLeft:Radius.circular(DimensionUtils.margin_xxlarge)),
                      child: Padding(
                      padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,0.0,DimensionUtils.margin_xxlarge,0.0),
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: <Widget>[
                        SizedBox(height: DimensionUtils.margin_xxxlarge),
                        Text("Login",textAlign: TextAlign.center,style: styleLarge.copyWith(color: ColorUtils.black)),
                        SizedBox(height: DimensionUtils.margin_xxxlarge),
                        emailField,
                        SizedBox(height: DimensionUtils.margin_xxlarge),
                        passwordField,
                        SizedBox(height: DimensionUtils.margin_xlarge),
                        loginButon,
                        SizedBox(
                          height:DimensionUtils.margin_medium,
                        )
                      ],
                      ),
                      ),
                      ),
                   )),
//        ),


                  ],
                ),
              ),
            ))
      ),
        ),


      ),
    );
  }

}
