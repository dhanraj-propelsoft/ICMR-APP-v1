
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
import 'package:wapindex/enterSampleResult.dart';
import 'package:wapindex/generate_refid_district.dart';
import 'package:wapindex/generate_refid_street.dart';
import 'package:wapindex/models/CommonResponseData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';
import 'package:wapindex/models/PaymentHistoryResponseData.dart';
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
import 'package:wapindex/samplesListScreen.dart';
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
import 'house_survey_one.dart';
import 'models/ProfileResponseData.dart';


class WasteWaterSubmenuScreen extends StatefulWidget {
  @override
  _WasteWaterSubmenuScreenState createState() => new _WasteWaterSubmenuScreenState();
}

class _WasteWaterSubmenuScreenState extends State<WasteWaterSubmenuScreen> {



  SharedPreferences? prefs;
  String? strAuthToken="";
  String strTitle=app_title;
  bool isFirst=true;



  initData() async {
    print("_homeScreenState initData................");

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);

  }



  final logger = Logger();





  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("WasteWaterSubmenuScreen dispose................");
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      print("WasteWaterSubmenuScreen setState................");
    }
  }




  void goBack(){
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showBottomSheet(context,bool isSampleGenerate){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(DimensionUtils.margin_large),topRight: Radius.circular(DimensionUtils.margin_large)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Wrap(children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, DimensionUtils.margin_large, 0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Align (
                        alignment:Alignment.topLeft,
                        child:Padding(
                          padding:EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_xlarge, 0, DimensionUtils.margin_large),
                          child: Text("Select Sampling Option",style: styleListMediumBold,),
                        )),

                    new Divider(),

                    SizedBox(height: DimensionUtils.margin_xxlarge,),

                    Container(
                      child: new Column(
                        children: <Widget>[

                          GestureDetector(
                              onTap: () {
                                goBack();
                                 if(isSampleGenerate){
                                   pushNextScreen(context, GenerateRefIdStreet());
                                 }

                              },
                              child:Container(
                                padding: EdgeInsets.all(DimensionUtils.margin_xlarge),
                                child:
                                Container(

                                    child:new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
//                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Image.asset("assets/images/ic_street.png",width: DimensionUtils.img_size_form_camera,height: DimensionUtils.img_size_form_camera,),
                                          Padding(padding: EdgeInsets.fromLTRB(DimensionUtils.margin_large,0,0,0),
                                              child:Text('Street Sampling',style:styleListMediumBold)),
                                        ]
                                    )
                                ),
                              )),

                          GestureDetector(
                              onTap: () {
                                if(isSampleGenerate){
                                  pushNextScreen(context, GenerateRefIdDistrict());
                                }

                              },
                              child:Container(
                                padding: EdgeInsets.all(DimensionUtils.margin_xlarge),
                                child:
                                Container(
//
                                    child:new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
//                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image.asset("assets/images/ic_district.png",width: DimensionUtils.img_size_form_camera,height: DimensionUtils.img_size_form_camera,),
                                          Padding(padding: EdgeInsets.fromLTRB(DimensionUtils.margin_large,0,0,0),
                                              child:Text('District Sampling',style:styleListMediumBold)),
                                        ]
                                    )

                                ),


                              )),


                        ],
                      ),
                    ),
                    SizedBox(height: DimensionUtils.margin_xxlarge,),
                  ],
                ))
          ],) ;
        }
    );
  }


  Widget _proposalPage() {
    return
//      Center(
//      child:
      Container(
          color: Colors.white,
//          child: Padding(
//              padding: EdgeInsets.all(DimensionUtils.margin_large),
          child:Container(
            color: Colors.white,
            child:Container(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: DimensionUtils.margin_xxxlarge,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,

                      children: [

                        //DropDown Selection View

                        InkWell(
                          onTap: (){
                            _showBottomSheet(context,true);
                          },
                          child: Container(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: DimensionUtils.margin_large,),
//                                    Image.asset("images/logo_icon.png",width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard ,),
                              new CircularPercentIndicator(
                                radius: DimensionUtils.img_size_dashboard_progress,
                                lineWidth: 3.0,
                                percent: 1.0,
//                                      center: Icon(Icons.home_outlined,color: ColorUtils.app_green,size: DimensionUtils.img_size_dashboard,),
                                center: Image.asset("assets/images/ic_ref_id.png",color: ColorUtils.app_green,width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard ,),
                                progressColor: ColorUtils.app_green,
                              ),
                              SizedBox(height: DimensionUtils.margin_large,),
                              Text("Generate",style: styleListMedium.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
                              Text("Sample Ref Id",style: styleListMedium.copyWith(color: ColorUtils.black)),
//                            Text("Steps",style: style.copyWith(color: ColorUtils.black),),
                              SizedBox(height: DimensionUtils.margin_large,),
//                            GestureDetector(
//                                onTap: (){
////                                  _proposalStatusBottomSheet(context);
//                                },
//                                child: Container(
//                                  padding: EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_small, DimensionUtils.margin_large, DimensionUtils.margin_small),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.all(Radius.circular(DimensionUtils.margin_large)),
//                                    color:ColorUtils.white,
//                                    border:Border.all(width: DimensionUtils.divider_size, color: ColorUtils.primary),
//
//                                  ),
//                                  child: Text("Start",style: style.copyWith(color: ColorUtils.black,),
//                                  ),
//                                )),

                            ],
                          ),),
                        ),



                        InkWell(
                          onTap: (){
//                            _showBottomSheet(context,false);
                          pushNextScreen(context,SamplesListScreen());
                          },
                          child: Container(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: DimensionUtils.margin_large,),
//                                Image.asset("images/logo_icon.png",width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard,),
                              new CircularPercentIndicator(
                                radius: DimensionUtils.img_size_dashboard_progress,
                                lineWidth: 3.0,
                                percent: 1.0,
                                center: Image.asset("assets/images/ic_sample.png",color: ColorUtils.app_green,width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard ,),
                                progressColor: ColorUtils.app_green,
                              ),
                              SizedBox(height: DimensionUtils.margin_large,),
                              Text("Enter",style: styleListMedium.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
                              Text("Sample Data",style: styleListMedium.copyWith(color: ColorUtils.black),),
//                            Text("BPM",style: style.copyWith(color: ColorUtils.black),),
//                            SizedBox(height: DimensionUtils.margin_large,),
//                            GestureDetector(
//                                onTap: (){
////                                  _proposalStatusBottomSheet(context);
//                                },
//                                child: Container(
//                                  padding: EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_small, DimensionUtils.margin_large, DimensionUtils.margin_small),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.all(Radius.circular(DimensionUtils.margin_large)),
//                                    color:ColorUtils.white,
//                                    border:Border.all(width: DimensionUtils.divider_size, color: ColorUtils.primary),
//
//                                  ),
//                                  child: Text("Start",style: style.copyWith(color: ColorUtils.black,),
//                                  ),
//                                )),



                            ],
                          ),),
                        ),


                      ],),

                    SizedBox(height: DimensionUtils.margin_large,),


                  ],
                )),
          )
//          )
      )
//    )
        ;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print("WasteWaterSubmenuScreen build................");
    if(isFirst){
      isFirst=false;
      print("WasteWaterSubmenuScreen build isFirst................");
      initData();
    }






    return new Scaffold(
      key:_scaffoldKey ,

      appBar:new AppBar(
          backgroundColor: ColorUtils.primary,
          automaticallyImplyLeading: true,
          title: new Text("Waste Water SARS-COVID",style:styleAppName.copyWith(color: ColorUtils.black)),
//        titleSpacing: DimensionUtils.margin_xlarge,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(DimensionUtils.margin_xxlarge),
            ),
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),color: ColorUtils.black,
            onPressed: () {
              goBack();
            },),

      ),

      body:Center(

        child: _proposalPage(),

      ),
    );
  }



}

