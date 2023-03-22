
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wapindex/LoginScreen.dart';
import 'package:wapindex/accountViewScreen.dart';
import 'package:wapindex/models/CommonResponseData.dart';
import 'package:wapindex/models/HouseSurveyResponseData.dart';
import 'package:wapindex/models/NameData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';
import 'package:wapindex/models/PaymentHistoryResponseData.dart';
import 'package:wapindex/models/PendingSamplesData.dart';
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
import 'package:wapindex/models/SearchResponseData.dart';
import 'package:wapindex/success_screen.dart';
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
import 'package:wapindex/widgets/gif_progress_widget.dart';
import 'package:wapindex/widgets/submitandcontinuebutton.dart';
import 'enterSampleResult.dart';
import 'models/ProfileResponseData.dart';
import 'models/SampleListResponseData.dart';


class SamplesListScreen extends StatefulWidget {


  @override
  _SamplesListScreenState createState() => new _SamplesListScreenState();
}

class _SamplesListScreenState extends State<SamplesListScreen> {

  SharedPreferences? prefs;
  String? strAuthToken="";
  bool isFirst=true;



  final houseHoldNoController = TextEditingController();
  bool isHouseHoldNo=true;
  bool isProgress = false;

  List<PendingSamplesData>? listData=[];

  initData(context) async {

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);

    sampleListRequest(context);

  }

  goNextScreen(String? strDate,String? zoneData,String? wardData,String? areaData,String? streetData,
      String? districtData,String? refID,bool? isDistrict,int? finalId){

    pushNextScreen(context,EnterSampleResult(strDate:strDate,zoneData:zoneData,wardData:wardData,
        areaData:areaData,streetData:streetData,isDistrict:isDistrict,districtData:districtData,
        refID:refID,finalId:finalId));
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
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void validateSearch(){

    String strData=houseHoldNoController.text.trim();

    if(strData.length>0){

      searchRequest(context, strData);


    }else{
      if(strData.length==0){
        setState(() {
          isHouseHoldNo=false;
        });
      }
    }

  }

  int getCheckBoxValue(bool isData){
    int res=0;
    if(isData){
      res=1;
    }
    return res;

  }

  void searchRequest(context,String sampleID) async{
//    pushNextScreen(context, SuccessScreen());
    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("searchRequest.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "reference_no":sampleID,
      };
      debugPrint("searchRequest.................2"+headerData.toString());
      debugPrint("searchRequest.................3"+data.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_SEARCH_SAMPLEDATA, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        SearchResponseData responseData = SearchResponseData.fromJson(
            response.data);

        if (responseData.success!) {

          String? strDate="";
          String? zoneData="";
          String  ? wardData="";
          String  ? areaData="";
          String  ? streetData="";
          String  ? districtData="";
          String  ? refID="";
          bool? isDistrict=false;
          int? finalId=0;

          if(responseData.data!.virusStatus==null){
            setState(() {
              if(responseData.data!.type=="District"){
                isDistrict=true;
              }

              if(isDistrict!){
                districtData= responseData.data!.districtname;
              }else{
                zoneData= responseData.data!.zonename;
                wardData= responseData.data!.wardname;
                streetData= responseData.data!.streetname;
                areaData="--";
              }

              strDate=CommonUtils.getSimpleDateFormatServer(responseData.data!.date!);
              refID=responseData.data!.referenceNo;
              finalId=responseData.data!.id;
            });

            goNextScreen(strDate,zoneData,wardData,areaData,streetData,
                districtData,refID,isDistrict,finalId);
          }else{
            CommonUtils.showErrorToast(context,"Already report submitted");
          }


        } else {
          CommonUtils.showErrorToast(context,"No Samples Found!");
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }


  }

  void sampleListRequest(context) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("sampleListRequest.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      debugPrint("sampleListRequest.................2"+headerData.toString());


      showProgress();
      Response? response = await callGetAPIServicewithHeader(APIUtils.API_SAMPLE_LIST, null,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        SamplesListResponseData responseData = SamplesListResponseData.fromJson(
            response.data);

        if (responseData.success!) {
            if(responseData.data!=null&&responseData.data!.length>0){
              setState(() {
                listData=responseData.data!;
              });

            }
        } else {
          setState(() {
            listData=[];
          });
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

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

  Widget getSamplesRowView(PendingSamplesData data){

    String? strDate="";
    String? zoneData="";
    String  ? wardData="";
    String  ? areaData="";
    String  ? streetData="";
    String  ? districtData="";
    String  ? refID="";
    bool? isDistrict=false;
    int? finalId;

        if(data!.type=="District"){
          isDistrict=true;
        }

        if(isDistrict!){
          districtData= data!.districtName;
        }else{
          zoneData= data!.zoneName;
          wardData= data!.wardName;
          streetData= data!.streetName;
          areaData="--";
        }
        strDate=CommonUtils.getSimpleDateFormatServer(data!.date!);
        refID=data!.referenceNo;
        finalId=data!.id;



    return Column(
      children:<Widget> [
        InkWell(
          onTap: (){
            goNextScreen(strDate,zoneData,wardData,areaData,streetData,
                districtData,refID,isDistrict,finalId);
          },
          child: Container(
              color: ColorUtils.white,
              padding: EdgeInsets.all(DimensionUtils.margin_large),
              child:Column(
                children:<Widget> [
                  SizedBox(height: DimensionUtils.margin_small),
                  Row(
                    children: [
                      Expanded(
                        flex: 1, // you can play with this value, by default it is 1
                        child: _getViewRow("Date", strDate),
                      ),
                      Expanded(
                        flex: 1,
                        child: _getViewRow("Ref Id", refID),
                      ),

                    ],
                  ),
                  SizedBox(height: DimensionUtils.margin_small),
                  isDistrict!?Column(
                    children: [
                      Row(
                        children: [
                          _getViewRow("District", districtData),
                        ],
                      ),
                    ],
                  ):Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1, // you can play with this value, by default it is 1
                            child: _getViewRow("Zone", zoneData),
                          ),
                          Expanded(
                            flex: 1,
                            child: _getViewRow("Ward No", wardData),
                          ),

                        ],
                      ),
                      SizedBox(height: DimensionUtils.margin_small),
                      Row(
                        children: [
                          Expanded(
                            flex: 1, // you can play with this value, by default it is 1
                            child: _getViewRow("Area", areaData!=null?areaData:"--"),
                          ),
                          Expanded(
                            flex: 1,
                            child: _getViewRow("Street", streetData),
                          ),

                        ],
                      )
                    ],
                  )

                ],
              )
          ),
        ),


        SizedBox(height: DimensionUtils.margin_large),


      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print("_homeScreenState build................");
    if(isFirst){
      isFirst=false;
      print("_homeScreenState build isFirst................");
      initData(context);
    }





    return GifProgressWidget(
      progress: isProgress,
      child: new Scaffold(
        key:_scaffoldKey ,

        appBar:new AppBar(
          backgroundColor: ColorUtils.primary,
          automaticallyImplyLeading: true,
          title: new Text("Waste Waster SARS- COVID",style:styleAppName.copyWith(color: ColorUtils.black)),
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


        body:SingleChildScrollView(
          child: Container(
            color: ColorUtils.grey,
            child: Padding(
              padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,DimensionUtils.margin_large,DimensionUtils.margin_xxlarge,DimensionUtils.margin_xxlarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [

                          Row(
                            children: [
                              Expanded(
                                flex: 3, // you can play with this value, by default it is 1
                                child: TextField(
                                  onChanged: (value){
                                    isHouseHoldNo = true;
                                    setState(() {});
                                  },
                                  controller: houseHoldNoController,
                                  obscureText: false,
                                  style: style,
                                  decoration: InputDecoration(
                                      contentPadding: edgeInsets,
                                      labelText: "Search By Ref Id",
                                      errorText: isHouseHoldNo?null:"Enter Ref Id",
                                      border: outlineInputBorder),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child:Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small),
                                  child: Material(color: Colors.transparent,child:InkWell(

                                    onTap: () {
                                      //FetchLocation
                                      validateSearch();
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: ColorUtils.primary),
                                      child: Padding(
                                        padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Search",
                                                textAlign: TextAlign.center,
                                                style: buttonStyle.copyWith(
                                                    color: ColorUtils.black, fontWeight: FontWeight.bold)),
                                            SizedBox(width: DimensionUtils.margin_small,),
                                            Icon(Icons.search,color: ColorUtils.black,)

                                          ],
                                        ),

                                      ),
                                    ),
                                  )),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: DimensionUtils.margin_small),
                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  for ( var vd in listData! ) getSamplesRowView(vd),
                  SizedBox(
                    height: DimensionUtils.margin_xxxlarge,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

