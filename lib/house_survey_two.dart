
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
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
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
import 'models/ProfileResponseData.dart';


class HouseSurveyTwo extends StatefulWidget {
  final String? strDate;
  final NameData? zoneData;
  final NameData  ? wardData;
  final NameData  ? areaData;
  final NameData  ? streetData;
  const HouseSurveyTwo({Key? key,required this.strDate,required this.zoneData,required this.wardData
    ,required this.areaData,required this.streetData}) : super(key: key);
  @override
  _HouseSurveyTwoState createState() => new _HouseSurveyTwoState();
}

class _HouseSurveyTwoState extends State<HouseSurveyTwo> {

  SharedPreferences? prefs;
  String? strAuthToken="";
  bool isFirst=true;
  DateTime currentDate = DateTime.now();
  final houseHoldNoController = TextEditingController();
  final houseLatitudeController = TextEditingController();
  final houseLongitudeController = TextEditingController();

  final hospitalNameController = TextEditingController();
  final hospitalLatitudeController = TextEditingController();
  final hospitalLongitudeController = TextEditingController();

  bool isHouseHoldNo=true;
  bool isHouseLat=true;
  bool isHouseLong=true;

  bool isHospitalName=true;
  bool isHospitalLat=true;
  bool isHospitalLong=true;

  bool? isAFI;
  bool? isARI;
  bool? isILI;
  bool? isSARI;
  bool isProgress = false;

  initData() async {

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);




  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
        lastDate:  DateTime.now());
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Future<void> getHouseUserLocation() async {
    try {
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        Location location = new Location();
        location.changeSettings(accuracy: LocationAccuracy.high);
        bool _serviceEnabled;
        _serviceEnabled = await location.serviceEnabled();
        debugPrint('locationserviceEnabled: ${_serviceEnabled}');
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            getHouseUserLocation();
            return;
          }
        }
        LocationData _locationData = await location.getLocation();
        double? latitude = _locationData.latitude;
        double? longitude = _locationData.longitude;
        debugPrint('Latitude: ${latitude} - Longitude: ${longitude}');
        setState(() {
          houseLatitudeController.text=latitude.toString();
          houseLongitudeController.text=longitude.toString();
        });
      }

    } catch (error) {
      print(error);
    }

  }

  Future<void> getHospitalLocation() async {
    try {
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        Location location = new Location();
        location.changeSettings(accuracy: LocationAccuracy.high);
        bool _serviceEnabled;
        _serviceEnabled = await location.serviceEnabled();
        debugPrint('locationserviceEnabled: ${_serviceEnabled}');
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            getHouseUserLocation();
            return;
          }
        }
        LocationData _locationData = await location.getLocation();
        double? latitude = _locationData.latitude;
        double? longitude = _locationData.longitude;
        debugPrint('Latitude: ${latitude} - Longitude: ${longitude}');
        setState(() {
        hospitalLatitudeController.text=latitude.toString();
        hospitalLongitudeController.text=longitude.toString();
        });
      }

    } catch (error) {
      print(error);
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

  void validate(){

    String houseNo=houseHoldNoController.text.trim();
    String houseLat=houseLatitudeController.text.trim();
    String houseLong=houseLongitudeController.text.trim();

    String hospitalName=hospitalNameController.text.trim();
    String hospitalLat=hospitalLatitudeController.text.trim();
    String hospitalLong=hospitalLongitudeController.text.trim();

    if(houseNo.length>0&&houseLat.length>0&&houseLong.length>0&&
    isAFI!=null&&isARI!=null&&isILI!=null&&isSARI!=null){

//      if(isSARI!=null&&isSARI!){
//        if(hospitalName.length>0&&hospitalLat.length>0&&hospitalLong.length>0){
          //Call API
          submitRequest(context, houseNo, houseLat, houseLong, hospitalName, hospitalLat, hospitalLong);
//        }
//        else{
//          if(hospitalName.length==0){
//            setState(() {
//              isHospitalName=false;
//            });
//          }
//          if(hospitalLat.length==0){
//            setState(() {
//              isHospitalLat=false;
//            });
//          }
//          if(hospitalLong.length==0){
//            setState(() {
//              isHospitalLong=false;
//            });
//          }
//        }
//      }else{
//       //Call API
//        submitRequest(context, houseNo, houseLat, houseLong, hospitalName, hospitalLat, hospitalLong);
//      }


    }else{
      if(houseNo.length==0){
        setState(() {
          isHouseHoldNo=false;
        });
      }
      if(houseLat.length==0){
        setState(() {
          isHouseLat=false;
        });
      }
      if(houseLong.length==0){
        setState(() {
          isHouseLong=false;
        });
      }

      if(isAFI==null||isARI==null||isILI==null||isSARI==null){
        CommonUtils.showErrorToast(context, "Select all options!");
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

  void submitRequest(context,String houseNo,String houselat,String houseLong,String hospitalName,String hospitalLat,String hospitalLong) async{
//    pushNextScreen(context, SuccessScreen());
    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("submitRequest.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "date": widget.strDate,
        "house_hold_no": houseNo,
        "street_id": widget.streetData!.id!,
        "house_latitude": houselat,
        "house_longitude": houseLong,
        "afi_virus": getCheckBoxValue(isAFI!),
        "ari_virus": getCheckBoxValue(isARI!),
        "ili_virus": getCheckBoxValue(isILI!),
        "sari_virus": getCheckBoxValue(isSARI!),
        "hospital_name": hospitalName,
        "hospitallatitude": hospitalLat,
        "hospitallongitude": hospitalLong,
      };
      debugPrint("submitRequest.................2"+headerData.toString());
      debugPrint("submitRequest.................3"+data.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_SUBMIT_HOUSE_SURVEY, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        HouseSurveyResponseData responseData = HouseSurveyResponseData.fromJson(
            response.data);

        if (responseData.success!) {
          pushNextScreen(context, SuccessScreen(responseData:responseData,isHouseSurvey: true,));
        } else {
          CommonUtils.showErrorToast(context, responseData.message);
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print("_homeScreenState build................");
    if(isFirst){
      isFirst=false;
      print("_homeScreenState build isFirst................");
      initData();
    }





    return GifProgressWidget(
      progress: isProgress,
      child: new Scaffold(
        key:_scaffoldKey ,

        appBar:new AppBar(
            backgroundColor: ColorUtils.primary,
            automaticallyImplyLeading: true,
            title: new Text("Survey House",style:styleAppName.copyWith(color: ColorUtils.black)),
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

                  SizedBox(height: DimensionUtils.margin_large),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text("2/2",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(widget.strDate!,style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),

                  SizedBox(height: DimensionUtils.margin_large),
              Container(
                color: ColorUtils.white,
                padding: EdgeInsets.all(DimensionUtils.margin_large),
                child:Column(
                  children:<Widget> [
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
                  ],
                )
              ),

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
                                      labelText: "House Hold No",
                                      errorText: isHouseHoldNo?null:"Enter house hold no",
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
                                      getHouseUserLocation();
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
                                            Text("Fetch",
                                                textAlign: TextAlign.center,
                                                style: buttonStyle.copyWith(
                                                    color: ColorUtils.black, fontWeight: FontWeight.bold)),
                                            SizedBox(width: DimensionUtils.margin_small,),
                                            Icon(Icons.location_on_outlined,color: ColorUtils.black,)

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
                          Row(
                            children: [
                              Expanded(
                                flex: 1, // you can play with this value, by default it is 1
                                child:  Padding(
                                  padding: EdgeInsets.only(right: DimensionUtils.margin_small),
                                  child: TextField(
                                    onChanged: (value){
                                      isHouseLat = true;
                                      setState(() {});
                                    },
                                    controller: houseLatitudeController,
                                    obscureText: false,
                                    style: style,
                                    decoration: InputDecoration(
                                        contentPadding: edgeInsets,
                                        labelText: "Latitude",
                                        errorText: isHouseLat?null:"Enter latitude",
                                        border: outlineInputBorder),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small),
                                  child: TextField(
                                    onChanged: (value){
                                      isHouseLong = true;
                                      setState(() {});
                                    },
                                    controller: houseLongitudeController,
                                    obscureText: false,
                                    style: style,
                                    decoration: InputDecoration(
                                        contentPadding: edgeInsets,
                                        labelText: "Longitude",
                                        errorText: isHouseLong?null:"Enter longitude",
                                        border: outlineInputBorder),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),

                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // you can play with this value, by default it is 1
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:Text("Yes",style: styleMedium.copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:Text("No",style: styleMedium.copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.center)
                                ),
                              ),

                            ],
                          ),

                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large,),
                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // you can play with this value, by default it is 1
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                  child: Text("AFI",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                  child:InkWell(
                                    onTap: (){
                                      setState(() {
                                        isAFI=true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorUtils.grey),
                                          color: isAFI!=null&&isAFI==true?ColorUtils.red:ColorUtils.grey
                                      ),

                                      child: Padding(
                                        padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                        child: isAFI!=null&&isAFI==true
                                            ? Icon(
                                          Icons.check,
                                          size: DimensionUtils.size_checkbox,
                                          color: ColorUtils.white,
                                        )
                                            : Icon(
                                          Icons.clear,
                                          size: DimensionUtils.size_checkbox,
                                          color:ColorUtils.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isAFI=false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isAFI!=null&&isAFI==false?ColorUtils.green:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isAFI!=null&&isAFI==false
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),

                            ],
                          ),
                          isAFI!=null?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select AFI",style: style.copyWith(color: ColorUtils.red),)),
                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // you can play with this value, by default it is 1
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                  child: Text("ARI",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isARI=true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isARI!=null&&isARI==true?ColorUtils.red:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isARI!=null&&isARI==true
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isARI=false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isARI!=null&&isARI==false?ColorUtils.green:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isARI!=null&&isARI==false
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),

                            ],
                          ),
                          isARI!=null?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select ARI",style: style.copyWith(color: ColorUtils.red),)),
                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // you can play with this value, by default it is 1
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                  child: Text("ILI",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isILI=true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isILI!=null&&isILI==true?ColorUtils.red:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isILI!=null&&isILI==true
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isILI=false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isILI!=null&&isILI==false?ColorUtils.green:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isILI!=null&&isILI==false
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),

                            ],
                          ),
                          isILI!=null?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select ILI",style: style.copyWith(color: ColorUtils.red),)),
                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  Container(
                      color: ColorUtils.white,
                      padding: EdgeInsets.all(DimensionUtils.margin_large),
                      child:Column(
                        children:<Widget> [
                          Row(
                            children: [
                              Expanded(
                                flex: 2, // you can play with this value, by default it is 1
                                child: Padding(
                                  padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                  child: Text("SARI",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isSARI=true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isSARI!=null&&isSARI==true?ColorUtils.red:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isSARI!=null&&isSARI==true
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small,right: DimensionUtils.margin_small),
                                    child:InkWell(
                                      onTap: (){
                                        setState(() {
                                          isSARI=false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorUtils.grey),
                                            color: isSARI!=null&&isSARI==false?ColorUtils.green:ColorUtils.grey
                                        ),

                                        child: Padding(
                                          padding:  EdgeInsets.all(DimensionUtils.margin_small),
                                          child: isSARI!=null&&isSARI==false
                                              ? Icon(
                                            Icons.check,
                                            size: DimensionUtils.size_checkbox,
                                            color: ColorUtils.white,
                                          )
                                              : Icon(
                                            Icons.clear,
                                            size: DimensionUtils.size_checkbox,
                                            color:ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),

                            ],
                          ),
                          isSARI!=null?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select SARI",style: style.copyWith(color: ColorUtils.red),)),
                        ],
                      )
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  Visibility(
                    visible: isSARI!=null&&isSARI==true?true:false,
                    child: Container(
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
                                      isHospitalName = true;
                                      setState(() {});
                                    },
                                    controller: hospitalNameController,
                                    obscureText: false,
                                    style: style,
                                    decoration: InputDecoration(
                                        contentPadding: edgeInsets,
                                        labelText: "Hospital Name",
                                        errorText: isHospitalName?null:"Enter hospital name",
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
                                        getHospitalLocation();
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
                                              Text("Fetch",
                                                  textAlign: TextAlign.center,
                                                  style: buttonStyle.copyWith(
                                                      color: ColorUtils.black, fontWeight: FontWeight.bold)),
                                              SizedBox(width: DimensionUtils.margin_small,),
                                              Icon(Icons.location_on_outlined,color: ColorUtils.black,)

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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1, // you can play with this value, by default it is 1
                                  child:  Padding(
                                    padding: EdgeInsets.only(right: DimensionUtils.margin_small),
                                    child: TextField(
                                      onChanged: (value){
                                        isHospitalLat = true;
                                        setState(() {});
                                      },
                                      controller: hospitalLatitudeController,
                                      obscureText: false,
                                      style: style,
                                      decoration: InputDecoration(
                                          contentPadding: edgeInsets,
                                          labelText: "Latitude",
                                          errorText: isHospitalLat?null:"Enter latitude",
                                          border: outlineInputBorder),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: DimensionUtils.margin_small),
                                    child: TextField(
                                      onChanged: (value){
                                        isHospitalLong = true;
                                        setState(() {});
                                      },
                                      controller: hospitalLongitudeController,
                                      obscureText: false,
                                      style: style,
                                      decoration: InputDecoration(
                                          contentPadding: edgeInsets,
                                          labelText: "Longitude",
                                          errorText: isHospitalLong?null:"Enter longitude",
                                          border: outlineInputBorder),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),
                  ),
                  SizedBox(height: DimensionUtils.margin_large),
                  SizedBox(height: DimensionUtils.margin_xlarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SubmitAndContinueButton(onTab: (){
                         validate();
                      }, text: "Next", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
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
      ),
    );
  }


}

