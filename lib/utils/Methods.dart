import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<Response?> callAPIServiceWithHeader(@required String url, Map? parm,Map<String,dynamic>? headerData,context) async {
  debugPrint("callAPIServiceWithHeader.............. "+url);
  Response? response;
  var dio = Dio();
  try {
    response = await dio.post(url,
      data: parm,
      options: Options(
        headers:headerData ,
        contentType: Headers.jsonContentType,
      ),
      onSendProgress: (int sent, int total) {
        debugPrint('$sent $total');
      },
    );

    debugPrint("Status Code:"+response.statusCode.toString());

    if(response!.statusCode==200){
      debugPrint(response!.data.toString());
    }else{
      showSnackbarMessage(context, 'HTTPS STATUS ERROR : '+response!.statusCode.toString());
    }

  }catch(e){
    debugPrint(e.toString());
    showSnackbarMessage(context, 'HTTP Error Occured. Please try later');
  }

  return response;
}


//Call GET API with Header
Future<Response?> callGetAPIServicewithHeader(@required String url, Map<String,dynamic>? parm,Map<String,dynamic>? headerData,context) async {
  debugPrint("callGetAPIServicewithHeader............ "+url);
  Response? response;
  var dio = Dio();

  try {
    response = await dio.get(url,queryParameters:parm ,
      options: Options(
        headers:headerData ,
        contentType: Headers.jsonContentType,
      ),
    );

    debugPrint("Status Code:"+response.statusCode.toString());

    if(response!.statusCode==200){
      debugPrint(response!.data.toString());
    }else{
      showSnackbarMessage(context, 'HTTPS STATUS ERROR : '+response!.statusCode.toString());
    }

  }catch(e){
    debugPrint(e.toString());
    showSnackbarMessage(context, 'HTTP Error Occured. Please try later');
  }

  return response;
}

Future<Response?> callMultipartAPIService(@required String url, FormData? formdata,Map<String,dynamic>? headerData,context) async {
  debugPrint("callMultipartAPIService................ "+url);
  Response? response;
  Dio dio =  Dio();

  // if(is_progress){
  //   pushNextScreen(context, ProgressScreen(text:progresstext));
  // }

  // if(url.startsWith(ROOT_OPAL_FILE)){
  //   String? strAuthToken=await getAuthTokenRequest(context);
  //   if(strAuthToken!=null&&strAuthToken.length>0){
  //     if(headerData!=null){
  //       headerData[AUTH_BEARER_KEY]=AUTH_BEARER_PREFIX+strAuthToken;
  //     }else{
  //       headerData={};
  //       headerData[AUTH_BEARER_KEY]=AUTH_BEARER_PREFIX+strAuthToken;
  //     }
  //     debugPrint("Header With Bearer.............. "+headerData.toString());
  //   }
  // }

  try {
    response = await dio.post(url,
      data: formdata,
      options: Options(
          headers:headerData ,
          method: 'POST',
          responseType: ResponseType.json // or ResponseType.JSON
      ),

      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );

    // if(is_progress){
    //   Navigator.of(context).pop();
    // }

    debugPrint("Status Code:"+response.statusCode.toString());

    if(response!.statusCode==200){
      debugPrint(response!.data.toString());
    }else{
      showSnackbarMessage(context, 'HTTPS STATUS ERROR : '+response!.statusCode.toString());
    }
  }
  catch(e){
    debugPrint("MultiPartError: "+e.toString());

    // if(is_progress){
    //   Navigator.of(context).pop();
    // }
    showSnackbarMessage(context, 'HTTP Error Occured. Please try later');

  }

  return response;
}

pushNextScreen(context,Widget screen){
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

pushNextReplacmentScreen(context,Widget screen){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

void showSnackbarMessage(context,String message){
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String formatDate(DateTime dd){
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(dd);
  return formatted;
}