//import 'dart:io';
//import 'dart:math';
//import 'dart:convert';
//import 'package:clay_containers/widgets/clay_container.dart';
//import 'package:dio/dio.dart';
//import 'package:flutter/gestures.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
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
//class accountViewScreen extends StatefulWidget {
//
//  @override
//  _AccountViewScreenState createState() => new _AccountViewScreenState();
//}
//
//
//
//class _AccountViewScreenState extends State<accountViewScreen> {
//  String strTitle="Details View";
//  SchemeDetailsData? tempViewData;
//  bool isFirst=true;
//  bool isPayments=false;
//  List<bool>? isSelected= [true, false];
//  List<PaymentHistoryData> alPaymentHistoryData=[];
//
//  String? strAuthToken;
//  SharedPreferences? prefs;
//
////  String strDemoPaymentToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOTlmODg5MjFkODA4MTk1NTg0ZGNkYzVhMmY4NWEwMDFkZTAwNWM4YmY0YTRiNTY1ZTdiMDhjM2NmMDRlMTRkODExYjc4ZmYxOWIzMmMwOTMiLCJpYXQiOjE2NDQ0MTExNzcuNDYwMDU3MDIwMTg3Mzc3OTI5Njg3NSwibmJmIjoxNjQ0NDExMTc3LjQ2MDA2MTA3MzMwMzIyMjY1NjI1LCJleHAiOjE2NzU5NDcxNzcuNDU3MjQwMTA0Njc1MjkyOTY4NzUsInN1YiI6Ijk1Iiwic2NvcGVzIjpbXX0.NhD5neqPdtAzNqWyZLojfBpQ6bJxCoz32uu3eX-uMi5zDok0ewYTM9FBUrB-wAiBi0dstpvgPsUM9MvaPS7lXojwqJ7nOMZ8dB2aao2Jh3n4_ZyWQp65sdU4GuXQ4FqqDNAS4t8qGPsw8xI1_RqamLHI3GT1Sbo0jC0WM_9fwi6PrEJ08anp3wiNxkyPEWLHfhFDJcmuwx9OpplQ0j00mBLoQ_jJEibinnixYpqFTqllLaqBLGHLNSQmmfI6FpB3GNOzS8ZnAzekQMVEWy-wUml-Tc5COoSX_9kgINoP0HWl5tBGSxSX2JG9BvovfX9u8MEDPuqatFDW6Cwb6u0SUBZmzTomHWP6bpayzv0aESLR3WoOzO2xeW-Kuj3-uNENDI7_gLPW8Zc078gifCbZUuYYcPtIGFjJIOE7UlixFp4lztJBYeMmcW7IIiWnT8foUuHfuRYikO-nYSHl4YqbpC3mhN3VSHcb7vUs7aiQodKBsZsYDKlfAfMXoxV5Ut8BJzXDGhq-HIYUUYNCNxx2tKxf05nx3fm6M_bQ4WF4lDSKkZjlNcfzP3tmv7LhFqaNoikefpMywmM5fWJKBBpcubAwd1F0apR3-ESNzOWzH0wVcYfI_a3Yt71M1yhk9prTHQCx8vM28aBVU8NU-620eHTus_f5MSeNzu2Mfnn9FCo";
////  String strDemoSchemeToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDVjNTFkMTVkNDEwNzExNTgyZmI2ZjY1ZGY1NzdkZjU0N2RhMDgzY2JkNzU3YWI5YWM3ZTMxZDQ1OTMyZjdmOTBiOTE0MGVjMmE4YjY0NWMiLCJpYXQiOjE2NDQwNTI5NzYuODgxOTE3OTUzNDkxMjEwOTM3NSwibmJmIjoxNjQ0MDUyOTc2Ljg4MTkyMjAwNjYwNzA1NTY2NDA2MjUsImV4cCI6MTY3NTU4ODk3Ni44NzY5NjkwOTkwNDQ3OTk4MDQ2ODc1LCJzdWIiOiI5NiIsInNjb3BlcyI6W119.xaTlgXya95AGlXn_sdLwsKseZ79nsb3JXZBnwK4pfFHdPA2k-S4_KCb8zUzyX_3onpjApP59juhakyXRz8uziakugFkB_HXmVs2iyx6e20uxZpr-E3wL8u1774sX0YfmP6Br3Y6lNnUGox7kyHfD2_CibPy44eC-VR8vJ8U1j25u2y7omcuv5skBTlTvLCZ6nnTA8jBAEgciTPTNgSjjVOTPbAteajxu9xNTObmpecerEHh3fTPE1hNKaczKSQy7PdY1bXdaT1ll4zSvrX4YTgHATHGD-Q7FEstBGzjgpYd63RhrxIFgUjmyfHqvE0njbn_N4K5ItrMhGFTO8TAVs8MV2YNw--NwxXWAF_UbEHrp7oBN8dEaMo06YGbLLZZWQXqAE1CBELoB4L4FpVWsF8jF9t46QrNyUBcJhR5urLRtIpQEFYtPvIgWkIwgBtCT63AFqHsXLLuRG_HJac7VxmuutC2cpfs1Ir3BQ6rjaEDmljxcHooGn66fx6XavgyJ180KG1OohpO2zDMaw-8s_fMkClx7fEK-jQZwTIvrndjnlu6hFLzBZb-p5Pe4vymVXNEYJl93f6Jitzu0Jay5v6arfN4Qii8AGt4v1_qOOfwsc8OtQTkKZp5oButEJGG59Kd_mCK-uRs4nMWul2_7P32jYM0AB5BNbJJAOZpMFL4";
//
////  @override
////  void initState() {
////    super.initState();
////    print("regCompany initState................");
////    initData();
////  }
//
//  initData() async {
//    print("regCompany initData................");
//
//    prefs = await SharedPreferences.getInstance();
//    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);
//    isSelected = [true, false];
//
//    if(CommonUtils.schemeData!.schemeId!=null) {
//      getSchemeDetails();
//    }
//
//
//  }
//
////  void tempPaymetDetails(){
////    PaymentHistoryData pd=new PaymentHistoryData();
////    pd.amount=2000;
////    pd.paymentDate=DateTime.parse("2022-02-01");
////    pd.paymentype="test";
////
////    PaymentHistoryData pd2=new PaymentHistoryData();
////    pd2.amount=3000;
////    pd2.paymentDate=DateTime.parse("2022-02-02");
////    pd2.paymentype="test";
////
////    setState(() {
////      alPaymentHistoryData.add(pd);
////      alPaymentHistoryData.add(pd2);
////    });
////
////  }
//
//
//
//  void getSchemeDetails() async{
//
//    Dio dio = new Dio();
////    Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
////      APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strDemoSchemeToken!};
//
//    Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
//      APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};
//
//
//    ProgressDialog pd = ProgressDialog(context: context);
//    pd.show(max: 100, msg: "Please wait...");
//    try {
//      var response = await dio.post(APIUtils.BASE_URL+APIUtils.API_SCHEMEDETAILS,
//        queryParameters: {"scheme_id":CommonUtils.schemeData!.schemeId.toString()},
//        options: Options(
//            headers: headerData
//        ),
////        data:  {"scheme_id":CommonUtils.schemeData!.schemeId.toString()},
//      );
//      pd.close();
//      logger.d("Response Code : "+response.statusCode.toString());
//      if (response.statusCode == 200) {
//        // If the server did return a 201 CREATED response,
//        // then parse the JSON.
//        logger.d("Response Data : "+response.data.toString());
//        SchemeDetailsResponseData loginResponse=SchemeDetailsResponseData.fromJson(response.data);
//        if(loginResponse.success!){
//
//          setState(() {
//            tempViewData=loginResponse.data;
//          });
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
//
//
//  }
//
//  void getPaymentDetails() async{
//
//    Dio dio = new Dio();
////    Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
////      APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strDemoPaymentToken!};
//
//    Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
//      APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};
//
//
//    ProgressDialog pd = ProgressDialog(context: context);
//    pd.show(max: 100, msg: "Please wait...");
//    var formdata = FormData.fromMap({
//      "scheme_id": CommonUtils.schemeData!.schemeId.toString(),
//    });
//    try {
//      var response = await dio.post(APIUtils.BASE_URL+APIUtils.API_PAYMENT_HISTORY,
//        options: Options(
//            headers: headerData
//        ),
//        data: formdata,
//
//      );
//      pd.close();
//      logger.d("Response Code : "+response.statusCode.toString());
//      if (response.statusCode == 200) {
//        // If the server did return a 201 CREATED response,
//        // then parse the JSON.
//        logger.d("Response Data : "+response.data.toString());
//        PaymentHistoryResponseData loginResponse=PaymentHistoryResponseData.fromJson(response.data);
//        if(loginResponse.success!){
//
//          setState(() {
//            alPaymentHistoryData=loginResponse!.data!;
//          });
//
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
////      tempPaymetDetails();
//    }
//
//  }
//
//
//  final logger = Logger();
//
//
//  String random() {
//    Random generator = new Random();
//
//    int num = generator.nextInt(99999) + 99999;
//    if (num < 100000 || num > 999999) {
//      num = generator.nextInt(99999) + 99999;
//      if (num < 100000 || num > 999999) {
//        throw new Exception("Unable to generate PIN at this time..");
//      }
//    }
//    return num.toString();
//  }
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
//  Widget _getViewRow(String label,String? value){
//    return Container(
//      child:Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
////          icon,
//          Padding(
//            padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
//            child:Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//              Align(
//                alignment:Alignment.topLeft,
//                child:Text(label,style:styleViewTitle ,),
//            ),
//
//              SizedBox(height: DimensionUtils.margin_medium,),
//              Align(
//                alignment:Alignment.topLeft,
//                  child:Container (
//                    width: MediaQuery.of(context).size.width*0.8,
//                    child:Text(value!=null?value:"--",style:style ),
//                  )
//              ),
//
//            ],)
//          )
//        ],
//      )
//    );
//  }
//
//  Widget _detailsPage(){
//    return tempViewData!=null?Container(
//      child:Column(children: <Widget>[
//        SizedBox(height: DimensionUtils.margin_xlarge,),
//        _getViewRow("Serial Order Number", tempViewData!.serialOrderNo),
//        SizedBox(height: DimensionUtils.margin_xxlarge,),
//        _getViewRow("Scheme Amount", tempViewData!.schemeAmount),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Total Number of Members", tempViewData!.totalNoOfSubsriber.toString()),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Monthly Subscriptions", tempViewData!.monthlySubscdiption),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Periods (in Months)", tempViewData!.period.toString()),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Started On",formatDate(tempViewData!.startedOn!) ),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Closure On",formatDate(tempViewData!.closureOn!)),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Number of dues Paid", tempViewData!.noOfDuesPaid.toString()),
//        SizedBox(height: DimensionUtils.margin_xxxlarge,),
//        _getViewRow("Number of dues Remaining", tempViewData!.noOfDuesRemaining.toString()),
//        SizedBox(height: DimensionUtils.margin_xxlarge,),
//        _getViewRow("Last Auction Date", tempViewData!.lAuctionDate),
//        SizedBox(height: DimensionUtils.margin_xxlarge,),
//        _getViewRow("Last Bidding Amount", tempViewData!.lBitAmount),
//        SizedBox(height: DimensionUtils.margin_xxlarge,),
//
//
//      ],)
//    ):SizedBox(height: DimensionUtils.margin_small,);
//  }
//
//
//  Widget getSingleRow( PaymentHistoryData md){
//    return Padding(
//      padding: EdgeInsets.fromLTRB(0, DimensionUtils.margin_small, 0,  DimensionUtils.margin_small),
//      child: Card(
//        color: ColorUtils.light_white,
//        elevation: 3,
//        shadowColor: ColorUtils.primary,
//        child: GestureDetector(
//          onTap: () {
////                            goDetails(md);
//
//          },
//          child:Container(
//              padding: EdgeInsets.all(DimensionUtils.margin_large),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
////
//                      child:new Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
////                                      crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Padding(padding: EdgeInsets.fromLTRB(0,0,0,0),
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    SizedBox(height: DimensionUtils.margin_large,),
//                                    _getViewRow("PSO.No", CommonUtils.schemeData!.name),
//                                    SizedBox(height: DimensionUtils.margin_small,),
//                                    _getViewRow("Due Amount", md!.amount.toString()),
//                                    SizedBox(height: DimensionUtils.margin_small,),
//                                    _getViewRow("Payment Date", formatDate(md.paymentDate!)),
//                                    SizedBox(height: DimensionUtils.margin_small,),
//                                    _getViewRow("Payment Type", md.paymentype.toString()),
//                                    SizedBox(height: DimensionUtils.margin_large,),
//
//                                  ],
//                                )
//                            ),
//                          ]
//                      )
//
//                  ),
//
//
//
//                ],
//              )),
////                    child:Text(md.name,style:style ,)
//        ),
//      ),
//    );
//  }
//
//  Widget _paymentPage(){
//      return Center(
////        child: _widgetOptions.elementAt(_selectedIndex),
//        child:Container(
//            color: ColorUtils.white,
//            child: Padding(
//                padding: EdgeInsets.all(0),
//                child:Container(
//                  color: ColorUtils.white,
//                  child:alPaymentHistoryData.length==0?Center(
//                      child: Text("No Record Found.",style: style,textAlign: TextAlign.center,)):
//                      Column(children: [
//                        for(var md in alPaymentHistoryData) getSingleRow(md)
//                      ],)
//                ))),
//      );
//
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    if(isFirst){
//      isFirst=false;
//      initData();
//    }
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
//        title: new Text(strTitle,style:styleAppName),
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
//        SingleChildScrollView(
//          child: Container(
//            color: Colors.white,
//            child: Padding(
//              padding:  EdgeInsets.fromLTRB(0,DimensionUtils.margin_large,0,0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.start,
//
//                children: <Widget>[
//
//                  SizedBox(height: DimensionUtils.margin_large),
//
//                  Container(
//                      child:ClayContainer(
//
//                          color: ColorUtils.white,
//                          depth: -15,
//                          customBorderRadius: BorderRadius.only(topRight:Radius.circular(DimensionUtils.margin_xxlarge),topLeft:Radius.circular(DimensionUtils.margin_xxlarge)),
//
//                      child:Container(
//                      padding: EdgeInsets.all(DimensionUtils.margin_xlarge),
//                      child:Column(
//
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          ToggleButtons(
////                          borderColor: ColorUtils.light_white,
//                            fillColor: ColorUtils.light_yellow,
//                            borderWidth: 0,
////                          selectedBorderColor: ColorUtils.yellow,
//                            selectedColor: ColorUtils.light_yellow,
//                            borderRadius: BorderRadius.circular(DimensionUtils.margin_xxlarge),
//                            children: <Widget>[
//
//                              Container(width: (MediaQuery.of(context).size.width-40 )/2, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('Scheme Details',style: isPayments?styleToggleNormal:styleToggleSelected,)],)),
//                              Container(width: (MediaQuery.of(context).size.width-40 )/2, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('Payment History',style: isPayments?styleToggleSelected:styleToggleNormal,)],)),
//
//                            ],
//                            onPressed: (int index) {
//                              setState(() {
//                                if(index==0){
//                                  isPayments=false;
//                                }else{
//                                  isPayments=true;
//                                  getPaymentDetails();
//                                }
//
//                                for (int i = 0; i < isSelected!.length; i++) {
//                                  isSelected![i] = i == index;
//                                }
//                              });
//                            },
//                            isSelected: isSelected!,
//                          ),
//                          SizedBox(height: DimensionUtils.margin_xlarge,),
//                          isPayments?_paymentPage():_detailsPage(),
//
//
//                        ],
//                      ))
//                  )),
//                  SizedBox(
//                    height: DimensionUtils.margin_xxxlarge,
//                  )
//                ],
//              ),
//            ),
//          ),
//        ),
//
//
//    );
//  }
//
//
//
//}