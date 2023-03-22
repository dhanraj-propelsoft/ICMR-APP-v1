
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
import 'package:wapindex/house_survey_two.dart';
import 'package:wapindex/models/CommonResponseData.dart';
import 'package:wapindex/models/DropdownResponseData.dart';
import 'package:wapindex/models/NameData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';
import 'package:wapindex/models/PaymentHistoryResponseData.dart';
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SamplingResponseData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
import 'package:wapindex/success_sampling_screen.dart';
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
import 'package:wapindex/utils/static_data.dart';
import 'package:wapindex/widgets/gif_progress_widget.dart';
import 'package:wapindex/widgets/submitandcontinuebutton.dart';
import 'models/ProfileResponseData.dart';


class GenerateRefIdStreet extends StatefulWidget {
  @override
  _GenerateRefIdStreetState createState() => new _GenerateRefIdStreetState();
}

class _GenerateRefIdStreetState extends State<GenerateRefIdStreet> {

  SharedPreferences? prefs;
  String? strAuthToken="";
  bool isFirst=true;
  DateTime currentDate = DateTime.now();
  NameData? selectedArea;
  NameData? selectedWardNo;
  NameData? selectedZone;
  NameData? selectedStreet;

  List<NameData> alZone=[];
  List<NameData> alWardNo=[];
  List<NameData> alArea=[];
  List<NameData> alStreet=[];

  bool isArea = true;
  bool isWardNo = true;
  bool isZone = true;
  bool isStreet = true;

  bool isProgress = false;

  final houseLatitudeController = TextEditingController();
  final houseLongitudeController = TextEditingController();

  bool isHouseLat=true;
  bool isHouseLong=true;

  initData() async {

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);

    resetWardlist();
    resetArealist();
    resetStreetlist();

    getZoneList(context);

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

  void submitRequest(context,String strDate,String houselat,String houseLong) async{
//    pushNextScreen(context, SuccessScreen());
    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("submitRequest.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "typeofSample": CommonUtils.SAMPLING_TYPE_STREET,
        "date": strDate,
        "street": selectedStreet!.id,
        "latitude": houselat,
        "longitude": houseLong,
      };
      debugPrint("submitRequest.................2"+headerData.toString());
      debugPrint("submitRequest.................3"+data.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_SUBMIT_WASTE_WATER, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        SamplingResponseData responseData = SamplingResponseData.fromJson(
            response.data);

        if (responseData.success!) {
          pushNextReplacmentScreen(context, SuccessSamplingScreen(strRefId: responseData.data!.referenceNo,
              strDate: strDate,zoneData: selectedZone, wardData: selectedWardNo, areaData: selectedArea, streetData: selectedStreet,
         latitude:houselat ,longitude: houseLong, type:  CommonUtils.SAMPLING_TYPE_STREET, responseData: responseData));
        } else {
          CommonUtils.showErrorToast(context, responseData.message);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }


  }

  void validate(){

    String houseLat=houseLatitudeController.text.trim();
    String houseLong=houseLongitudeController.text.trim();
    String strDate=CommonUtils.getSimpleDateFormatServer(currentDate);
    if(selectedZone!.id!=0&&selectedWardNo!.id!=0&&selectedStreet!.id!=0&&houseLat.length>0&&houseLong.length>0){
      submitRequest(context, strDate,houseLat, houseLong);
    }else{
      if(selectedZone!.id==0){
        setState(() {
          isZone=false;
        });
      }
      if(selectedWardNo!.id==0){
        setState(() {
          isWardNo=false;
        });
      }
      if(selectedStreet!.id==0){
        setState(() {
          isStreet=false;
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
    }

  }

  void resetZonelist(){
    setState(() {
      alZone.add(new NameData(0, "Select Zone"));
      selectedZone=alZone[0];
//      alWardNo.add(new NameData(2, "Pettavaithalai"));
    });
  }

  void resetWardlist(){
    setState(() {
      alWardNo.add(new NameData(0, "Select Ward Number"));
      selectedWardNo=alWardNo[0];
//      alWardNo.add(new NameData(2, "Pettavaithalai"));
    });
  }

  void resetArealist(){
    setState(() {
      alArea.add(new NameData(0, "Select Area"));
      selectedArea=alArea[0];
//      alArea.add(new NameData(2, "Nagavaram road"));
    });
  }

  void resetStreetlist(){
    setState(() {
      alStreet.add(new NameData(0, "Select Street"));
      selectedStreet=alStreet[0];
//      alStreet.add(new NameData(2, "Sivan Kovil Street"));
    });
  }

  NameData getFirstIndexDropDown(String strText){
    return NameData(0, strText);
  }

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

  void getZoneList(context) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("getZoneList.................1");

      resetZonelist();

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

//      Map<String, dynamic> data = {
//        "email": email,
//        "password": password,
//      };
      debugPrint("getZoneList.................2"+headerData.toString());

      showProgress();
      Response? response = await callGetAPIServicewithHeader(APIUtils.API_GET_ZONE_LIST, null,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
//        CommonResponseData responseData=CommonResponseData.fromJson(response.data);

        setState(() {
          alZone=response.data!=null?List<NameData>.from(response.data.map((x) => NameData.fromJson(x))):[];
          alZone.insert(0, getFirstIndexDropDown("Select Zone"));
          selectedZone=alZone[0];
        });


//        if(responseData.success!){
//          logout(context);
//        }else{
//          CommonUtils.showErrorToast(context, responseData.message);
//        }

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }


  }




  void getWardlistByZone(context,int zoneId) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("getWardlistByZone.................1");
      resetWardlist();

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "zoneId": zoneId,
      };
      debugPrint("getWardlistByZone.................2"+headerData.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_GET_WARD_LIST, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        DropdownResponseData responseData=DropdownResponseData.fromJson(response.data);




        if(responseData.success!){
          setState(() {
            alWardNo=responseData.data!;
            alWardNo.insert(0, getFirstIndexDropDown("Select Ward No"));
          });
        }else{
          alWardNo.insert(0, getFirstIndexDropDown("Select Ward No"));
          CommonUtils.showErrorToast(context, responseData.message);
        }

        selectedWardNo=alWardNo[0];

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }


  }

  void getArealistByWard(context,int wardId) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("getArealistByWard.................1");
      resetArealist();
      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "wardId": wardId,
      };
      debugPrint("getArealistByWard.................2"+headerData.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_GET_AREA_LIST, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        DropdownResponseData responseData=DropdownResponseData.fromJson(response.data);

        if(responseData.success!){
          setState(() {
            alArea=responseData.data!;
            alArea.insert(0, getFirstIndexDropDown("Select Area"));
          });
        }else{
          alArea.insert(0, getFirstIndexDropDown("Select Area"));
          CommonUtils.showErrorToast(context, responseData.message);
        }

        selectedArea=alArea[0];

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }


  }

  void getStreetlistByWard(context,int wardId) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("getStreetlistByWard.................1");

      resetStreetlist();

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      Map<String, dynamic> data = {
        "wardId": wardId,
      };
      debugPrint("getStreetlistByWard.................2"+headerData.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_GET_STREET_LIST, data,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        DropdownResponseData responseData=DropdownResponseData.fromJson(response.data);

        if(responseData.success!){
          setState(() {
            alStreet=responseData.data!;
            alStreet.insert(0, getFirstIndexDropDown("Select Street"));
          });
        }else{
          alStreet.insert(0, getFirstIndexDropDown("Select Street"));
          CommonUtils.showErrorToast(context, responseData.message);
        }

        selectedStreet=alStreet[0];

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }


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


  void resetData(){
    setState(() {
      selectedZone=alZone[0];
      selectedWardNo=alWardNo[0];
      selectedArea=alArea[0];
      selectedStreet=alStreet[0];
      currentDate=DateTime.now();
    });
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


    final zoneField=Container(
        padding: EdgeInsets.symmetric(horizontal: DimensionUtils.margin_large),
        decoration: dropDownDecoration,
        child:DropdownButtonHideUnderline(child:DropdownButton<NameData>(
          isExpanded: true,
          hint:  Text("Select Zone",style: styleDropdownHint),
          value: selectedZone,
          onChanged: (NameData? Value) {
            print("OnChange : "+Value!.name!);
            setState(() {
              selectedZone = Value;
              isZone=true;
              if(selectedZone!=null&&selectedZone!.id!=0){
                getWardlistByZone(context,selectedZone!.id!);
              }

            });
          },
          items: alZone.map((NameData data) {
            return  DropdownMenuItem<NameData>(
              value: data,
              child: Row(
                children: <Widget>[
                  SizedBox(width:  DimensionUtils.margin_large,),
                  Text(
                    data.name!,
                    style:  style,
                  ),
                ],
              ),
            );
          }).toList(),
        )));

    final wardField=Container(
        padding: EdgeInsets.symmetric(horizontal:  DimensionUtils.margin_large),
        decoration: dropDownDecoration,
        child:DropdownButtonHideUnderline(child:DropdownButton<NameData>(
          isExpanded: true,
          hint:  Text("Select Ward no",style: styleDropdownHint),
          value: selectedWardNo,
          onChanged: (NameData? Value) {
            print("OnChange : "+Value!.name!);
            setState(() {
              selectedWardNo = Value;
              isWardNo=true;

              if(selectedWardNo!=null&&selectedWardNo!.id!=0){
                getArealistByWard(context,selectedWardNo!.id!);
                getStreetlistByWard(context,selectedWardNo!.id!);
              }
            });
          },
          items: alWardNo.map((NameData data) {
            return  DropdownMenuItem<NameData>(
              value: data,
              child: Row(
                children: <Widget>[
                  SizedBox(width:  DimensionUtils.margin_large,),
                  Text(
                    data.name!,
                    style:  style,
                  ),
                ],
              ),
            );
          }).toList(),
        )));

    final areaField=Container(
        padding: EdgeInsets.symmetric(horizontal:  DimensionUtils.margin_large),

        decoration: dropDownDecoration,
        child:DropdownButtonHideUnderline(child:DropdownButton<NameData>(
          isExpanded: true,
          hint:  Text("Select Area",style: styleDropdownHint),
          value: selectedArea,
          onChanged: (NameData? Value) {
            print("OnChange : "+Value!.name!);
            setState(() {
              selectedArea = Value;
              isArea=true;
//              if(selectedArea!=null&&selectedArea.id!=null){
//                getStateList(selectedArea.id,null);
//              }
            });
          },
          items: alArea.map((NameData data) {
            return  DropdownMenuItem<NameData>(
              value: data,
              child: Row(
                children: <Widget>[
                  SizedBox(width:  DimensionUtils.margin_large,),
                  Text(
                    data.name!,
                    style:  style,
                  ),
                ],
              ),
            );
          }).toList(),
        )));

    final streetField=Container(
        padding: EdgeInsets.symmetric(horizontal:  DimensionUtils.margin_large),
        decoration: dropDownDecoration,
        child:DropdownButtonHideUnderline(child:DropdownButton<NameData>(
          isExpanded: true,
          hint:  Text("Select Street",style: styleDropdownHint,),
          value: selectedStreet,
          onChanged: (NameData? Value) {
            print("OnChange : "+Value!.name!);
            setState(() {
              selectedStreet = Value;
              isStreet=true;
            });
          },
          items: alStreet.map((NameData data) {
            return  DropdownMenuItem<NameData>(
              value: data,
              child: Row(
                children: <Widget>[
                  SizedBox(width:  DimensionUtils.margin_large,),
                  Text(
                    data.name!,
                    style:  style,
                  ),
                ],
              ),
            );
          }).toList(),
        )));



    return WillPopScope(
      onWillPop: () async {
        // Do something here
        goBack();
        return false;
      },
      child: GifProgressWidget(
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
              color: Colors.white,
              child: Padding(
                padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge,DimensionUtils.margin_large,DimensionUtils.margin_xxlarge,DimensionUtils.margin_xxlarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: DimensionUtils.margin_large),

                    Container(
                      padding: EdgeInsets.only(left: DimensionUtils.margin_large,right: DimensionUtils.margin_large),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(DimensionUtils.margin_large),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey, spreadRadius: 1),
                        ],
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(CommonUtils.getSimpleDateFormatServer(currentDate),style: style,),
                          IconButton(
                            onPressed: (){
                              _selectDate(context);
                            },
                            icon: Icon(Icons.calendar_today_rounded),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height:  DimensionUtils.margin_xlarge),

                    zoneField,
                    isZone?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select Zone",style: style.copyWith(color: ColorUtils.red),)),
                    SizedBox(height: DimensionUtils.margin_xlarge),
                    wardField,
                    isWardNo?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select Ward No",style: style.copyWith(color: ColorUtils.red),)),
                    SizedBox(height:DimensionUtils.margin_xlarge),
                    areaField,
//                isArea?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select Area",style: style.copyWith(color: ColorUtils.red),)),
                    SizedBox(height: DimensionUtils.margin_xlarge),
                    streetField,
                    isStreet?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select Street",style: style.copyWith(color: ColorUtils.red),)),
                    SizedBox(height: DimensionUtils.margin_xlarge),
                    Container(
                        color: ColorUtils.white,
                        padding: EdgeInsets.all(DimensionUtils.margin_large),
                        child:Column(
                          children:<Widget> [

                            Row(
                              children: [
                                Expanded(
                                  flex: 3, // you can play with this value, by default it is 1
                                   child:Text("")
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
                    SizedBox(height: DimensionUtils.margin_xlarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SubmitAndContinueButton(onTab: (){
                          validate();

                        }, text: "Generate Ref Id", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
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
      ),
    );
  }


}

