class UserReportResponseData {
  UserReportResponseData({
    this.successs,
    this.message,
    this.data,
  });

  bool? successs;
  String? message;
  Data? data;

  factory UserReportResponseData.fromJson(Map<String, dynamic> json) => UserReportResponseData(
    successs: json["successs"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "successs": successs,
    "message": message,
    "data": data!.toJson(),
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
