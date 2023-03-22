
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:wapindex/models/SchemeData.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'DimensionUtils.dart';



class CommonUtils{

  static final String COMMON_FAILED="Failed",COMMON_SUCCESS="Success";

  static final String MEDIA_TYPE_IMAGE="image",MEDIA_TYPE_VIDEO="video";

  static final int SAMPLING_TYPE_STREET=1,SAMPLING_TYPE_DISTRICT=2;

  static List<String> alMembers=[];
  static  SchemeData? schemeData;

  static String getSimpleDateFormatServer(DateTime dtime){
    String formattedDate = DateFormat('dd-MMM-yyyy').format(dtime);
//    String formattedDate = DateFormat('yyyy-MM-dd').format(dtime);
    return formattedDate;
  }

  static String getSimpleMonthFormatServer(DateTime dtime){
    String formattedDate = DateFormat('MMM').format(dtime);
    return formattedDate;
  }

  static ProgressDialog getProgressDialog(context){
//    ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs:false);
    ProgressDialog pr = new ProgressDialog(context:context);
    return pr;
  }

  static void showProgressBar(ProgressDialog pr){
      if(pr!=null) {
        pr.show(max: 100, msg: "Please wait...");
      }
  }

  static void hideProgressBar(ProgressDialog pr){
    Future.delayed(Duration(seconds: 0)).then((onValue){
      if(pr!=null&&pr.isOpen()) {
        pr.close();
      }
    }
    );

  }



  static showToast(context,var message){
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showSuccessToast(context,var message){
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showErrorToast(context,var message){
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showRequestErrorToast(context,int statusCode,String responseBody){
    SnackBar snackBar = SnackBar(
      content: Text(getReposeStatusText(statusCode)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  static showSessionErrorToast(context){
    SnackBar snackBar = SnackBar(
      content: Text("Session timeout."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String getGenderText(int genderId){

    if(genderId==1){
      return "Male";
    }else if(genderId==2){
      return "Female";
    }else if(genderId==3){
      return "Others";
    }else{
      return "Others";
    }
  }

  static bool isValidMobile(String strMobile){

    bool isValid=false;
    if(strMobile.length>=7&&strMobile.length<=13){
      isValid=true;
    }

    return isValid;
  }

  static String getReposeStatusText(int statusCode){

    if(statusCode==400){
      return "Bad Request";
    }else if(statusCode==401){
      return "Unauthorised Access";
    }else if(statusCode==403){
      return "Access Forbidden";
    }else if(statusCode==500){
      return "Internal Server Error";
    }else if(statusCode==404){
      return "Failed";
    }
    return "Failed";
  }




}