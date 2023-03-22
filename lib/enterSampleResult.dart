
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as p;
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
import 'models/ProfileResponseData.dart';


class EnterSampleResult extends StatefulWidget {

  final String? strDate;
  final String? zoneData;
  final String  ? wardData;
  final String  ? areaData;
  final String  ? streetData;
  final String  ? districtData;
  final String  ? refID;
  final int? finalId;
  final bool? isDistrict;



  const EnterSampleResult({Key? key,required this.strDate,required this.zoneData,required this.wardData
    ,required this.areaData,required this.streetData,required this.isDistrict,required this.districtData,required this.refID,required this.finalId}) : super(key: key);

  @override
  _EnterSampleResultState createState() => new _EnterSampleResultState();
}

class _EnterSampleResultState extends State<EnterSampleResult> {

  SharedPreferences? prefs;
  String? strAuthToken="";
  bool isFirst=true;

  final bool? isShow=true;
   bool? isAFI;
   String? strFileName;
   File? selectedFile;

  bool isProgress = false;

  final rdrpGeneController = TextEditingController();
  final eGeneController = TextEditingController();

  initData() async {

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);

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


  int getCheckBoxValue(bool isData){
    int res=0;
    if(isData){
      res=1;
    }
    return res;

  }


  void validate(){

    if(isAFI!=null){
      submitRequest(context);
    }else{
      if(isAFI==null){
        CommonUtils.showErrorToast(context, "Select Result!");
      }
    }

  }

  void submitRequest(context) async{
//    pushNextScreen(context, SuccessScreen());
    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("submitRequest.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};



      FormData formData = FormData.fromMap({
        "sars_virus_result": getCheckBoxValue(isAFI!),
        "rdrp_gene":rdrpGeneController.text,
        "e_gene":eGeneController.text,
        'pdf_file': selectedFile!=null?await MultipartFile.fromFile(selectedFile!.path, filename: p.basename(selectedFile!.path)):"",
      });

      debugPrint("submitRequest.................2"+headerData.toString());


      showProgress();
      String strUrl=APIUtils.API_RESULT_UPDATE_PART1+"/"+widget.finalId.toString()+APIUtils.API_RESULT_UPDATE_PART2;
      Response? response=await callMultipartAPIService(strUrl,formData,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        HouseSurveyResponseData responseData = HouseSurveyResponseData.fromJson(
            response.data);
        if ( response.data["successs"]==true) {
//        if (responseData.success!) {
          pushNextScreen(context, SuccessScreen(responseData:responseData,isHouseSurvey: false,));
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
                  SizedBox(height: DimensionUtils.margin_large),
                  isShow!?Column(
                    children:<Widget> [
                      Container(
                          color: ColorUtils.white,
                          padding: EdgeInsets.all(DimensionUtils.margin_large),
                          child:Column(
                            children:<Widget> [
                              SizedBox(height: DimensionUtils.margin_small),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1, // you can play with this value, by default it is 1
                                    child: _getViewRow("Date", widget.strDate),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _getViewRow("Ref Id",  widget.refID),
                                  ),

                                ],
                              ),
                              SizedBox(height: DimensionUtils.margin_small),
                              widget.isDistrict!?Column(
                                children: [
                                  Row(
                                    children: [
                                      _getViewRow("District",  widget.districtData),
                                    ],
                                  ),
                                ],
                              ):Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1, // you can play with this value, by default it is 1
                                        child: _getViewRow("Zone",  widget.zoneData),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: _getViewRow("Ward No",  widget.wardData),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: DimensionUtils.margin_small),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1, // you can play with this value, by default it is 1
                                        child: _getViewRow("Area",  widget.areaData!=null? widget.areaData:"--"),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: _getViewRow("Street",  widget.streetData),
                                      ),

                                    ],
                                  )
                                ],
                              )

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
                                      child: Text("SARS COV -2",style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
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
                              isAFI!=null?SizedBox(height: 0):Padding(padding: EdgeInsets.only(top: DimensionUtils.margin_medium) ,child:Text("Select SARS COV -2",style: style.copyWith(color: ColorUtils.red),)),
                            ],
                          )
                      ),
                      SizedBox(height: DimensionUtils.margin_large),
                      TextField(
                        onChanged: (value){
                          setState(() {});
                        },
                        controller: rdrpGeneController,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            contentPadding: edgeInsets,
                            labelText: "Rdrp gene",
                            border: outlineInputBorder),
                      ),
                      SizedBox(height: DimensionUtils.margin_large),
                      TextField(
                        onChanged: (value){
                          setState(() {});
                        },
                        controller: eGeneController,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            contentPadding: edgeInsets,
                            labelText: "E gene",
                            border: outlineInputBorder),
                      ),
                      SizedBox(height: DimensionUtils.margin_large),
                      SubmitAndContinueButton(onTab: () async {
                        //pick file
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg', 'png', 'jpeg','pdf'],);
                        if (result != null) {
                          File file = File(result.files.single.path.toString());
                          if(file!=null){
                            setState(() {
                              selectedFile=file;
                              strFileName=p.basename(selectedFile!.path);
                            });

                          }
                        }
                      }, text: "Upload Positive Report ", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
                      SizedBox(height: DimensionUtils.margin_small),
                      Text(strFileName!=null?strFileName!:"",style: style,),
                      SizedBox(height: DimensionUtils.margin_large),
                      SizedBox(height: DimensionUtils.margin_xlarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SubmitAndContinueButton(onTab: (){
                            validate();
                          }, text: "Submit", gradientColor1: ColorUtils.primary, gradientColor2: ColorUtils.app_green),
                        ],
                      ),
                    ],
                  ):SizedBox(height: 0,),


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

