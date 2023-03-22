//import 'dart:io';
//import 'dart:math';
//import 'dart:convert';
//import 'package:clay_containers/widgets/clay_container.dart';
//import 'package:dio/dio.dart';
//import 'package:flutter/gestures.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:wapindex/models/CommonResponseData.dart';
//import 'package:wapindex/models/PaymentHistoryData.dart';
//import 'package:wapindex/models/SchemeDetailsData.dart';
//import 'package:wapindex/utils/APIUtils.dart';
//import 'package:wapindex/utils/ColorUtils.dart';
//import 'package:wapindex/utils/CommonUtils.dart';
//import 'package:wapindex/utils/DimensionUtils.dart';
//import 'package:wapindex/utils/Methods.dart';
//import 'package:wapindex/utils/PreferenceUtils.dart';
//import 'package:wapindex/utils/StyleUtils.dart';
////import 'dart:io';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:logger/logger.dart';
//import 'package:sn_progress_dialog/progress_dialog.dart';
//
//import 'models/PaymentHistoryResponseData.dart';
//import 'models/SchemeDetailsResponseData.dart';
//
//
//class ForgotPasswordScreen extends StatefulWidget {
//
//  @override
//  _ForgotPasswordScreenState createState() => new _ForgotPasswordScreenState();
//}
//
//
//
//class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//  final mobileController = TextEditingController();
//  bool isMobile = true;
//  String strMobileError="Enter mobile number";
//
//  initData() async {
//    print("regCompany initData................");
//
//
//  }
//
//
//
//  void forgot(){
//    var mobileNumber=mobileController.text.trim();
//
//    if(mobileNumber.length>0&&mobileNumber.length==10){
//      forgotRequest(mobileNumber);
//    }else{
//      if(mobileNumber.length==0){
//        isMobile=false;
//        strMobileError="Enter mobile number";
//        setState(() {});
//      }if(mobileNumber.length!=10){
//        isMobile=false;
//        strMobileError="Enter valid mobile number";
//        setState(() {});
//      }
//    }
//
//  }
//
//  void forgotRequest(String email) async{
//
//
//    Dio dio = new Dio();
//    var formdata = FormData.fromMap({
//      "mobile1": email,
//    });
//
//    ProgressDialog pd = ProgressDialog(context: context);
//    pd.show(max: 100, msg: "Please wait...");
//    try {
//      var response = await dio.post(APIUtils.BASE_URL+APIUtils.API_FORGOT_PASSWORD, data: formdata);
//      pd.close();
//      logger.d("Response Code : "+response.statusCode.toString());
//      if (response.statusCode == 200) {
//        // If the server did return a 201 CREATED response,
//        // then parse the JSON.
//        logger.d("Response Data : "+response.data.toString());
//        CommonResponseData loginResponse=CommonResponseData.fromJson(response.data);
//        if(loginResponse.success!){
//          CommonUtils.showSuccessToast("Password information sent to your mobile number.");
//          goBack();
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
//
//  }
//
//
//  final logger = Logger();
//
//
//  void goBack(){
//    if (Navigator.canPop(context)) {
//      Navigator.pop(context);
//    }
//  }
//
//
//
//  void setTextFieldValue(String value,TextEditingController controller){
//    try{
//      if(value!=null&&value.length>0){
//        controller.text=value;
//      }
//    } catch (e) {
//      print(e.toString());
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    final emailField = TextField(
//      onChanged: (value){
//        isMobile = true;
//        setState(() {});
//      },
//      controller: mobileController,
//      obscureText: false,
//      style: style,
//      decoration: InputDecoration(
//          contentPadding: edgeInsets,
//          labelText: "Mobile Number",
//          errorText: isMobile?null:strMobileError,
//          border: outlineInputBorder),
//    );
//
//
//    final loginButon =Material(color: Colors.transparent,child:InkWell(
//
//      onTap: () {
//        forgot();
////        startTime();
//      },
//      child: Ink(
//        width: 200,
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(20),
//            color: ColorUtils.primary),
//        child: Padding(
//          padding: const EdgeInsets.all(12.0),
//          child:Text("Submit",
//              textAlign: TextAlign.center,
//              style: buttonStyle.copyWith(
//                  color: Colors.white, fontWeight: FontWeight.bold)),
//        ),
//      ),
//    ));
//
//    var size =MediaQuery.of(context).size.height / 100;
//    var topSize=size*35;
//    var bottomSize=size*65;
//
//    return Scaffold(
//      backgroundColor: ColorUtils.white,
//
//      appBar: new AppBar(
//
//        automaticallyImplyLeading: true,
////        backgroundColor: ColorUtils.white,
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        actionsIconTheme: IconThemeData(
////            size: 30.0,
//          color: ColorUtils.primary,
////            opacity: 10.0
//        ),
//
//        title: new Text("Forgot Password",style:styleAppName),
//        titleSpacing: DimensionUtils.margin_xlarge,
//        leading: IconButton(icon:Icon(Icons.arrow_back),color: ColorUtils.primary,
//          onPressed: () {
//            goBack();
//          },),
//
//      ),
//
//
//      body:
//      SingleChildScrollView(
//          child:
//          Center(
//
//              child: Container(
//                color: Color(0xfff9f9f9),
//                child: Padding(
//                  padding: const EdgeInsets.all(0.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//
//                      Container(
//                          height: topSize,
//                          child:Column(children: <Widget>[
//                            SizedBox(height: DimensionUtils.margin_xxxxlarge),
//                            Image.asset('assets/images/logo_icon.png',width: DimensionUtils.img_size_login_logo,height: DimensionUtils.img_size_login_logo)
//                            ,
//                            SizedBox(height: DimensionUtils.margin_xxxlarge),
//                            Text("SAARAM CHITS",style:styleLarge),
//                            SizedBox(height: DimensionUtils.margin_xlarge),
//                          ],)
//                      ),
////            ClipRRect(
////
////              borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0)),
//
//
//                      Container(
//                          height: bottomSize,
//                          child:ClayContainer(
//                            color: ColorUtils.white,
//                            depth: -15,
//                            customBorderRadius: BorderRadius.only(topRight:Radius.circular(DimensionUtils.margin_xxlarge),topLeft:Radius.circular(DimensionUtils.margin_xxlarge)),
//                            child: Padding(
//                              padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,0.0,DimensionUtils.margin_xxlarge,0.0),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                mainAxisAlignment: MainAxisAlignment.start,
//
//                                children: <Widget>[
//                                  SizedBox(height: DimensionUtils.margin_xxxlarge),
//                                  Text("Forgot Password",textAlign: TextAlign.center,style: styleLarge),
//                                  SizedBox(height: DimensionUtils.margin_xxxlarge),
//                                  emailField,
//                                  SizedBox(height: DimensionUtils.margin_xxlarge),
//                                  loginButon,
//                                  SizedBox(
//                                    height:DimensionUtils.margin_medium,
//                                  )
//                                ],
//                              ),
//                            ),
//                          )),
////        ),
//
//
//                    ],
//                  ),
//                ),
//              ))
//      ),
//
//
//    );
//  }
//
//
//
//}