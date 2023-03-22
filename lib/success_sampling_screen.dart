
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
import 'models/SamplingResponseData.dart';


class SuccessSamplingScreen extends StatefulWidget {
  String? strRefId;
  int? type;
   String? strDate;
   NameData? zoneData;
   NameData  ? wardData;
   NameData  ? areaData;
   NameData  ? streetData;
  String? latitude;
  String? longitude;
  SamplingResponseData? responseData;

   SuccessSamplingScreen({Key? key,required this.strRefId,required this.type,required this.strDate,required this.zoneData,required this.wardData
    ,required this.areaData,required this.streetData,required this.latitude,required this.longitude,required this.responseData}) : super(key: key);

  @override
  _SuccessSamplingScreenState createState() => new _SuccessSamplingScreenState();
}

class _SuccessSamplingScreenState extends State<SuccessSamplingScreen> {

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
//    Navigator.restorablePushAndRemoveUntil(context,
//      StaticData.myRouteBuilderHome,
//      ModalRoute.withName('/'),
//    );
    Navigator.of(context).pop();
  }

  void goHome(){
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
    var topSize=size*20;
    var bottomSize=size*80;

    Widget _getViewRow(String label,String? value){
      return Container(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding:EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, 0, 0),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment:Alignment.topLeft,
                        child:Text(label,style:styleViewTitle.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold) ,),
                      ),

                      SizedBox(height: DimensionUtils.margin_medium,),
                      Align(
                        alignment:Alignment.topLeft,
                        child:Text(value!=null?value:"--",style:style ,),
                      ),

                    ],)
              )
            ],
          )
      );
    }


    return WillPopScope(
      onWillPop: () async {
        // Do something here
        goBack();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key:_scaffoldKey ,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
//                              height: topSize,
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
//                                      Text("Successfully submitted",style: styleLarge.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
//                                      SizedBox(height: DimensionUtils.margin_large),
                                        Text("Reference Id : "+widget.strRefId!,style: styleLarge.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
                                        SizedBox(height: DimensionUtils.margin_large),
                                      ],
                                    ),
                                  ),
                                )
                            ),
//            ClipRRect(
//
//              borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0)),


                            Container(
//                              height: bottomSize,
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
                                          SizedBox(height: DimensionUtils.margin_xlarge),
                                          Container(
                                              color: ColorUtils.white,
                                              padding: EdgeInsets.all(DimensionUtils.margin_large),
                                              child:widget.type==CommonUtils.SAMPLING_TYPE_STREET?Column(
                                                children:<Widget> [
                                                  Text("Date : "+widget.strDate!,style: styleLarge.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
                                                  SizedBox(height: DimensionUtils.margin_small),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1, // you can play with this value, by default it is 1
                                                        child: _getViewRow("Zone", widget.zoneData!.name!),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: _getViewRow("Ward No", widget.wardData!.name!),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: DimensionUtils.margin_small),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1, // you can play with this value, by default it is 1
                                                        child: _getViewRow("Area", widget.areaData!.id!=null?widget.areaData!.name!:"--"),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: _getViewRow("Street", widget.streetData!.name!),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: DimensionUtils.margin_small),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1, // you can play with this value, by default it is 1
                                                        child: _getViewRow("Latitude", widget.latitude),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: _getViewRow("Longitude", widget.longitude),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ):Column(
                                                children:<Widget> [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1, // you can play with this value, by default it is 1
                                                        child: _getViewRow("District", widget.zoneData!.name!),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:_getViewRow("Date", widget.strDate!),
                                                      ),

                                                    ],
                                                  ),

                                                  SizedBox(height: DimensionUtils.margin_small),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1, // you can play with this value, by default it is 1
                                                        child: _getViewRow("Latitude", widget.latitude),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: _getViewRow("Longitude", widget.longitude),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              )

                                          ),
                                          Text("History",textAlign: TextAlign.center,style: styleLarge.copyWith(color: ColorUtils.black)),
                                          SizedBox(height: DimensionUtils.margin_xlarge),
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
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              SubmitAndContinueButton(onTab: (){
                                                goHome();
                                              }, text: "Done", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),

                                              SubmitAndContinueButton(onTab: (){
                                               goBack();

                                              }, text: "New Data", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
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

