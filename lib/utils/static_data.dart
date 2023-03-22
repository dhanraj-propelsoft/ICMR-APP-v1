
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wapindex/house_survey_one.dart';

import '../homeScreen.dart';

class StaticData{



  static Route<void> myRouteBuilderHome(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => homeScreen(),
    );
  }

  static Route<void> myRouteBuilderHouseSurveyOne(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => HouseSurveyOne(),
    );
  }


}
