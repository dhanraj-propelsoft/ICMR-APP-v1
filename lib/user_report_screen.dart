
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wapindex/LoginScreen.dart';
import 'package:wapindex/accountViewScreen.dart';
import 'package:wapindex/house_survey_two.dart';
import 'package:wapindex/models/CommonResponseData.dart';
import 'package:wapindex/models/HouseSurveyResponseData.dart';
import 'package:wapindex/models/NameData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';
import 'package:wapindex/models/PaymentHistoryResponseData.dart';
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
import 'package:wapindex/utils/APIUtils.dart';
import 'package:wapindex/utils/ColorUtils.dart';
import 'package:wapindex/utils/CommonUtils.dart';
import 'package:wapindex/utils/DimensionUtils.dart';
import 'package:wapindex/utils/Methods.dart';
import 'package:wapindex/utils/PreferenceUtils.dart';
import 'package:wapindex/utils/StringResource.dart';
import 'package:wapindex/utils/StyleUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:wapindex/utils/static_data.dart';
import 'package:wapindex/widgets/submitandcontinuebutton.dart';
import 'models/ProfileResponseData.dart';
import 'models/UserReportResponseData.dart';


class UserReportScreen extends StatefulWidget {

  UserReportResponseData? responseData;
  bool? isHouseSurvey=false;
  UserReportScreen({Key? key,required this.responseData}) : super(key: key);

  @override
  _UserReportScreenState createState() => new _UserReportScreenState();
}

class _UserReportScreenState extends State<UserReportScreen> {

  SharedPreferences? prefs;
  String? strAuthToken="";
  bool isFirst=true;
  DateTime currentDate = DateTime.now();

  String strHouseStartDate="01-APR-2022";
  String strHouseEndDate="11/05/2022";
  int houseRangeValue=20;
  int houseTotalValue=2000;

  String strWaterStartDate="01-APR-2022";
  String strWaterEndDate="12/05/2022";
  int waterRangeValue=30;
  int waterTotalValue=3000;


  initData() async {

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);

    setState(() {
      strHouseEndDate=CommonUtils.getSimpleDateFormatServer(currentDate);
      strWaterEndDate=CommonUtils.getSimpleDateFormatServer(currentDate);

      houseRangeValue=widget.responseData!.data!.totalhouseDatascount!;
      houseTotalValue=widget.responseData!.data!.todayhouseDatascount!;
      waterRangeValue=widget.responseData!.data!.totalsampleDatascount!;
      waterTotalValue=widget.responseData!.data!.todaysampleDatascount!;
    });


  }


  final logger = Logger();





  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("_homeScreenState dispose................");
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      print("_homeScreenState setState................");
    }
  }

  void goBack(){
    Navigator.restorablePushAndRemoveUntil(context,
      StaticData.myRouteBuilderHome,
      ModalRoute.withName('/'),
    );
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print("_homeScreenState build................");
    if(isFirst){
      isFirst=false;
      print("_homeScreenState build isFirst................");
      initData();
    }

    var size =MediaQuery.of(context).size.height / 100;
    var topSize=size*35;
    var bottomSize=size*65;



    return WillPopScope(
      onWillPop: () async {
        // Do something here
        goBack();
        return false;
      },
      child: Scaffold(
        key:_scaffoldKey ,
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
                              child:Container(
                                child: Padding(
                                  padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,DimensionUtils.margin_large,DimensionUtils.margin_xxlarge,DimensionUtils.margin_xxlarge),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[

                                      Padding(
                                        padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorUtils.grey),
                                              color: ColorUtils.white
                                          ),

                                          child: Padding(
                                              padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                              child:Icon(
                                                Icons.check,
                                                size: DimensionUtils.img_size_success,
                                                color: ColorUtils.green,
                                              )
                                          ),
                                        ),

                                      ),
                                      SizedBox(height: DimensionUtils.margin_large),
                                      Text("User Report",style: styleLarge.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),

                                      SizedBox(height: DimensionUtils.margin_xxxlarge),

                                    ],
                                  ),
                                ),
                              )
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
                                        Text("History",textAlign: TextAlign.center,style: styleLarge.copyWith(color: ColorUtils.black)),
                                        SizedBox(height: DimensionUtils.margin_xxlarge),
                                        Text("House Data",textAlign: TextAlign.center,style: style.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold)),
                                        SizedBox(height: DimensionUtils.margin_large),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3, // you can play with this value, by default it is 1
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(strHouseStartDate+" to "+strHouseEndDate,style: style.copyWith(fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(" : "+houseRangeValue.toString(),style: style),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: DimensionUtils.margin_large),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3, // you can play with this value, by default it is 1
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text("Today Survey",style: style.copyWith(fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(" : "+houseTotalValue.toString(),style: style),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: DimensionUtils.margin_xxlarge),
                                        Text("Waste Water SARS-COVID",textAlign: TextAlign.center,style: style.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold)),
                                        SizedBox(height: DimensionUtils.margin_large),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3, // you can play with this value, by default it is 1
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(strWaterStartDate+" to "+strWaterEndDate,style: style.copyWith(fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(" : "+waterRangeValue.toString(),style: style),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: DimensionUtils.margin_large),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3, // you can play with this value, by default it is 1
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text("Today Survey",style: style.copyWith(fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                                child: Text(" : "+waterTotalValue.toString(),style: style),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: DimensionUtils.margin_xxxlarge),
                                        Row(
                                          mainAxisAlignment:  widget.isHouseSurvey!?MainAxisAlignment.spaceAround:MainAxisAlignment.center,
                                          children: <Widget>[
                                            SubmitAndContinueButton(onTab: (){
                                              goBack();
                                            }, text: "Done", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),

                                            Visibility(
                                              visible: widget.isHouseSurvey!,
                                              child: SubmitAndContinueButton(onTab: (){
                                                Navigator.restorablePushAndRemoveUntil(context,
                                                  StaticData.myRouteBuilderHouseSurveyOne,
                                                  ModalRoute.withName('/'),
                                                );
                                              }, text: "New Data", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
                                            ),
                                          ],
                                        ),
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

    return new Scaffold(
      key:_scaffoldKey ,

      body:SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Padding(
            padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,DimensionUtils.margin_large,DimensionUtils.margin_xxlarge,DimensionUtils.margin_xxlarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: DimensionUtils.margin_xxxlarge),
                Padding(
                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorUtils.grey),
                        color: ColorUtils.green
                    ),

                    child: Padding(
                        padding:  EdgeInsets.all(DimensionUtils.margin_small),
                        child:Icon(
                          Icons.check,
                          size: DimensionUtils.img_size_success,
                          color: ColorUtils.white,
                        )
                    ),
                  ),

                ),
                SizedBox(height: DimensionUtils.margin_large),
                Text("Successfully submitted",style: styleMedium.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),

                SizedBox(height: DimensionUtils.margin_xxxlarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SubmitAndContinueButton(onTab: (){

                    }, text: "Done", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
                  ],
                ),

                SizedBox(
                  height: DimensionUtils.margin_xxxlarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}

