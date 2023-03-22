class HouseSurveyResponseData {
  HouseSurveyResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory HouseSurveyResponseData.fromJson(Map<String, dynamic> json) => HouseSurveyResponseData(
    success: json["success"],
    data: json["data"]!=null?Data.fromJson(json["data"]):null,
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.totalhouseDatascount,
    this.todayhouseDatascount,
    this.totalsampleDatascount,
    this.todaysampleDatascount,
  });

  int? totalhouseDatascount;
  int? todayhouseDatascount;
  int? totalsampleDatascount;
  int? todaysampleDatascount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalhouseDatascount: json["totalhouseDatascount"],
    todayhouseDatascount: json["todayhouseDatascount"],
    totalsampleDatascount: json["totalsampleDatascount"],
    todaysampleDatascount: json["todaysampleDatascount"],
  );

  Map<String, dynamic> toJson() => {
    "totalhouseDatascount": totalhouseDatascount,
    "todayhouseDatascount": todayhouseDatascount,
    "totalsampleDatascount": totalsampleDatascount,
    "todaysampleDatascount": todaysampleDatascount,
  };
}
