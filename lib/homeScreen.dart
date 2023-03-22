
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
import 'package:wapindex/changePasswordScreen.dart';
import 'package:wapindex/models/CommonResponseData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';
import 'package:wapindex/models/PaymentHistoryResponseData.dart';
import 'package:wapindex/models/ProfileData.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:wapindex/models/SchemeDetailsResponseData.dart';
import 'package:wapindex/models/SchemeListResponseData.dart';
import 'package:wapindex/user_report_screen.dart';
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
import 'package:wapindex/waste_water_submenu.dart';
import 'package:wapindex/widgets/gif_progress_widget.dart';
import 'house_survey_one.dart';
import 'models/ProfileResponseData.dart';
import 'models/UserReportResponseData.dart';


class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => new _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {



  SharedPreferences? prefs;
  String? strAuthToken="";
  String? strUserName="";
  String? strMobile="";
  String strTitle=app_title;
  bool isFirst=true;
  bool isDahboardSelected=false;
  bool isLibrarySelected=false;
  bool isChangePassword=false;
//  bool isChangePasswordSelected=false;
  String? str_selfie_path;
  bool isProgress = false;


  initData() async {
    print("_homeScreenState initData................");

    prefs = await SharedPreferences.getInstance();
    strAuthToken=prefs!.getString(PreferenceUtils.PREF_AUTH_TOKEN);
    setState(() {
      strUserName=prefs!.getString(PreferenceUtils.PREF_USERNAME);
      strMobile=prefs!.getString(PreferenceUtils.PREF_MOBILE);
    });


  }

  void getUserReport(context) async{
//    pushNextScreen(context, SuccessScreen());
    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("getUserReport.................1");

      Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
        APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

      debugPrint("getUserReport.................2"+headerData.toString());


      showProgress();
      Response? response = await callGetAPIServicewithHeader(APIUtils.API_GET_USER_REPORT, null,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        UserReportResponseData responseData = UserReportResponseData.fromJson(
            response.data);

        if (responseData.successs!) {
          pushNextScreen(context, UserReportScreen(responseData:responseData));
        } else {
          CommonUtils.showErrorToast(context, responseData.message);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }


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

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
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


  void logoutRequest(context) async{

    try {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
      debugPrint("logoutRequest.................1");

     Map<String,dynamic> headerData = {APIUtils.HEADER_KEY_ACCEPT: APIUtils.CONTENT_TYPE_JSON,
      APIUtils.HEADER_KEY_AUTHORIZATION:APIUtils.AUTH_PREFIX+strAuthToken!};

//      Map<String, dynamic> data = {
//        "email": email,
//        "password": password,
//      };
      debugPrint("logoutRequest.................2"+headerData.toString());

      showProgress();
      Response? response = await callAPIServiceWithHeader(APIUtils.API_LOGOUT, null,headerData,context);
      hideProgress();
      if (response!=null&&response.statusCode == 200) {
        CommonResponseData responseData=CommonResponseData.fromJson(response.data);

        if(responseData.success!){
          logout(context);
        }else{
          CommonUtils.showErrorToast(context, responseData.message);
        }

      } else {

      }

    } catch (error) {
      debugPrint(error.toString());
    }


  }


//   void goPaymentDetails(SchemeData mdata){
//    CommonUtils.schemeData!=mdata;
//    pushNextScreen(context, accountViewScreen());
//  }








  void logout(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PreferenceUtils.saveBoolean(prefs,PreferenceUtils.PREF_LOGIN_STATUS, false);
    pushNextReplacmentScreen(context, LoginScreen());
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
                            pushNextScreen(context, HouseSurveyOne());
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
                                center: Image.asset("assets/images/ic_house.png",color: ColorUtils.app_green,width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard ,),
                                progressColor: ColorUtils.app_green,
                              ),
                              SizedBox(height: DimensionUtils.margin_large,),
                              Text("House",style: styleListMedium.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
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
                            pushNextScreen(context, WasteWaterSubmenuScreen());
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
                                center: Image.asset("assets/images/ic_waste_water.png",color: ColorUtils.app_green,width: DimensionUtils.img_size_dashboard,height:DimensionUtils.img_size_dashboard ,),
                                progressColor: ColorUtils.app_green,
                              ),
                              SizedBox(height: DimensionUtils.margin_large,),
                              Text("Waste Water",style: styleListMedium.copyWith(color: ColorUtils.black,fontWeight: FontWeight.bold),),
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
    print("_homeScreenState build................");
    if(isFirst){
      isFirst=false;
      print("_homeScreenState build isFirst................");
      initData();
    }






    return GifProgressWidget(
      progress:  isProgress,
      child: new Scaffold(
        key:_scaffoldKey ,
        drawer:
        SafeArea(child:
        Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),

            child:Drawer(

              child: Container(

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight:Radius.circular(DimensionUtils.margin_xxlarge),bottomRight:Radius.circular(DimensionUtils.margin_xxlarge)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
//                          offset: const Offset(2.0, 2.0),
                          blurRadius: 0.3,
                          spreadRadius: 0.0,
                        ),
                      ]

                  ),

                  child:ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(

                        margin: EdgeInsets.only(bottom: 0.0),
                        decoration: BoxDecoration(
                            gradient:
                            LinearGradient(colors: [ColorUtils.primary, ColorUtils.app_green],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(DimensionUtils.margin_xlarge)
                        ),
                        child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: DimensionUtils.img_size_slider_profile,
                                height: DimensionUtils.img_size_slider_profile,
//                                decoration: new BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    image: str_selfie_path!=null?DecorationImage(
//                                      fit: BoxFit.cover,
//                                      // image: AssetImage("assets/images/gpu/above18_Profile.png")
//                                      image: FileImage(File(str_selfie_path!)),
//                                    ):DecorationImage(
//                                      fit: BoxFit.fill,
//                                      image: AssetImage("assets/images/above18_Profile.png"),
//                                    )
//                                )),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorUtils.white
                          ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(strUserName!=null&&strUserName!.length>0?strUserName!.substring(0,1).toUpperCase():"",
                                textAlign: TextAlign.center,style: styleLarge.copyWith(color: ColorUtils.black),),
                            ),),
                            SizedBox(width: DimensionUtils.margin_large,),
                          Container(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(strUserName!,style: styleMedium.copyWith(fontWeight: FontWeight.bold),),
                                      SizedBox(height: DimensionUtils.margin_large,),
                                      Text(strMobile!,style: style.copyWith(color: ColorUtils.light_black),),
//                                      SizedBox(height: DimensionUtils.margin_small,),
//                                      Text("Developer",style: style.copyWith(color: ColorUtils.light_black),),
                                    ],
                                  )

                                   ),


                          ],
                        ),),
                      SizedBox(height: DimensionUtils.margin_xxlarge),
                      _createDrawerItemDashboard(context:context, imageData:Icons.home, text: 'Home',
                          onTap: (){

                          }
                          ),

                      _createDrawerItemLibrary(context:context, imageData:Icons.report, text: 'User Report',
                          onTap: () {

                          }),

                      _createDrawerItemChangePassword(context:context, imageData:Icons.lock, text: 'Change Password',
                          onTap: () {

                          }),


                      SizedBox(height: DimensionUtils.margin_xxlarge),
                      _createFooterItem(
                          context: context,
                          imageData:"assets/images/ic_sidemenu_logout_active.png",
                          text: 'Logout',
                          onTap: () {
//                           logoutRequest(context);
                             }
                            ),
      ],
      )

      ),
      )),
      ),
      appBar:new AppBar(
        backgroundColor: ColorUtils.primary,

        title: new Text(strTitle,style:styleAppName.copyWith(color: ColorUtils.black)),
//        titleSpacing: DimensionUtils.margin_xlarge,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(DimensionUtils.margin_xxlarge),
          ),
        ),
        leading: IconButton(icon:Icon(Icons.menu,color: ColorUtils.black,size: DimensionUtils.img_size_appbar,),
          onPressed: () {

            _scaffoldKey.currentState!.openDrawer();
//            Scaffold.of(context).openDrawer();
          },
        ),
      ),


//      bottomNavigationBar: BottomNavigationBar(
//        items:  <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon:  Icon(Icons.home,color: ColorUtils.light_black,),
//            activeIcon: Icon(Icons.home,color: ColorUtils.primary),
//            label: "Home",
//          ),
//          BottomNavigationBarItem(
//            icon:  Icon(Icons.supervised_user_circle_outlined,color: ColorUtils.light_black,),
//            activeIcon: Icon(Icons.supervised_user_circle_outlined,color: ColorUtils.primary),
//            label: "Profile",
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: ColorUtils.primary,
//
//        onTap: _onItemTapped,
//      ),

      body:Center(

          child: _proposalPage(),

        ),
      ),
    );
  }


  Widget _createDrawerItemDashboard(
      {context,IconData? imageData , String? text, GestureTapCallback? onTap}) {
    return Material(color: Colors.transparent,child:InkWell(
        child:ListTile(

          title: Container(
              padding:isDahboardSelected? EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large)
                  :EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, DimensionUtils.margin_large, 0),
              decoration: isDahboardSelected?BoxDecoration(
                  borderRadius: BorderRadius.circular(DimensionUtils.margin_large),
                  color: ColorUtils.primary.withOpacity(0.1)):BoxDecoration(color: ColorUtils.white),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
         child: Icon(imageData,color: isDahboardSelected?ColorUtils.primary:ColorUtils.light_black,)),
//                      child: Image.asset(imageData!,color: isDahboardSelected?ColorUtils.primary:ColorUtils.light_black)),
//            child: SvgPicture.asset("images/ic_feather_pie_chart.svg")),

                  Align(
                      alignment: Alignment.center,
                      child:
                      Padding(
                        padding: EdgeInsets.only(left: DimensionUtils.margin_xlarge),
                        child: Text(text!,style: isDahboardSelected?styleDrawerMenu.copyWith(color: ColorUtils.primary):styleDrawerMenu,),
                      )
                  ),
                ],
              )),
          onTap: (){
            setState(() {
              isDahboardSelected=true;
              isLibrarySelected=false;
              isChangePassword=false;
//              isSettingsSelected=false;

            });
          },
        )
    )
    );
  }


  Widget _createDrawerItemLibrary(
      {context,IconData? imageData , String? text, GestureTapCallback? onTap}) {
    return Material(color: Colors.transparent,child:InkWell(
        child:ListTile(

          title:  Container(
              padding:isLibrarySelected? EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large)
                  :EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, DimensionUtils.margin_large, 0),
              decoration: isLibrarySelected?BoxDecoration(
                  borderRadius: BorderRadius.circular(DimensionUtils.margin_large),
                  color: ColorUtils.primary.withOpacity(0.1)):BoxDecoration(color: ColorUtils.white),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
         child: Icon(imageData,color: isLibrarySelected?ColorUtils.primary:ColorUtils.light_black)),
//                      child: Image.asset(imageData!,color: isLibrarySelected?ColorUtils.primary:ColorUtils.light_black)),
//            child: SvgPicture.asset("images/ic_feather_pie_chart.svg")),

                  Align(
                      alignment: Alignment.center,
                      child:
                      Padding(
                        padding: EdgeInsets.only(left: DimensionUtils.margin_xlarge),
                        child: Text(text!,style: isLibrarySelected?styleDrawerMenu.copyWith(color: ColorUtils.primary):styleDrawerMenu,),
                      )
                  ),
                ],
              )),
          onTap: (){
            setState(() {
              isDahboardSelected=false;
              isLibrarySelected=true;
              isChangePassword=false;
              getUserReport(context);
            });
//            Navigator.of(context).pushNamed(RoutesUtils.libraryScreen);
          },
        )
    )
    );
  }

  Widget _createDrawerItemChangePassword(
      {context,IconData? imageData , String? text, GestureTapCallback? onTap}) {
    return Material(color: Colors.transparent,child:InkWell(
        child:ListTile(

          title:  Container(
              padding:isChangePassword? EdgeInsets.fromLTRB(DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large, DimensionUtils.margin_large)
                  :EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, DimensionUtils.margin_large, 0),
              decoration: isChangePassword?BoxDecoration(
                  borderRadius: BorderRadius.circular(DimensionUtils.margin_large),
                  color: ColorUtils.primary.withOpacity(0.1)):BoxDecoration(color: ColorUtils.white),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Icon(imageData,color: isChangePassword?ColorUtils.primary:ColorUtils.light_black)),
//                      child: Image.asset(imageData!,color: isLibrarySelected?ColorUtils.primary:ColorUtils.light_black)),
//            child: SvgPicture.asset("images/ic_feather_pie_chart.svg")),

                  Align(
                      alignment: Alignment.center,
                      child:
                      Padding(
                        padding: EdgeInsets.only(left: DimensionUtils.margin_xlarge),
                        child: Text(text!,style: isChangePassword?styleDrawerMenu.copyWith(color: ColorUtils.primary):styleDrawerMenu,),
                      )
                  ),
                ],
              )),
          onTap: (){
            setState(() {
              isDahboardSelected=false;
              isLibrarySelected=false;
              isChangePassword=true;
              Navigator.of(context).pop();
              pushNextScreen(context, ChangePasswordScreen());
//              getUserReport(context);
            });
//            Navigator.of(context).pushNamed(RoutesUtils.libraryScreen);
          },
        )
    )
    );
  }

  Widget _createFooterItem(
      {context,String? imageData , String? text, GestureTapCallback? onTap}) {
    return Material(color: Colors.transparent,child:InkWell(child:ListTile(

      title: Container(
          padding:EdgeInsets.fromLTRB(DimensionUtils.margin_large, 0, DimensionUtils.margin_large, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
//         child: Icon(icon,color: ColorUtils.light_black,)),
                  child: Image.asset(imageData!,color: ColorUtils.red)),
//            child: SvgPicture.asset("images/ic_feather_pie_chart.svg")),

              Align(
                  alignment: Alignment.center,
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: DimensionUtils.margin_xlarge),
                    child: Text(text!,style: styleDrawerFooter,),
                  )
              ),
            ],
          )),
//      title: Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Icon(icon,color: ColorUtils.red,),
//
//          Padding(
//            padding:EdgeInsets.only(left: DimensionUtils.margin_xlarge),
//            child: Text(text,style: styleDrawerFooter),
//          )
//        ],
//      ),
      onTap: (){
        setState(() {
          isDahboardSelected=false;
          isLibrarySelected=false;
          isChangePassword=false;

        });

        logoutRequest(context);
      },
    )));
  }

}

