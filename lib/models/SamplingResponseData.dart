class SamplingResponseData {
  SamplingResponseData({
    this.success,
//    this.type,
    this.message,
    this.data,
  });

  bool? success;
//  String? type;
  String? message;
  Data? data;

  factory SamplingResponseData.fromJson(Map<String, dynamic> json) => SamplingResponseData(
    success: json["success"],
//    type: json["type"],
    message: json["message"],
    data: json["data"]!=null?Data.fromJson(json["data"]):null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
//    "type": type,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.referenceNo,
    this.date,
    this.zoneName,
    this.wardName,
    this.streetName,
    this.areaName,
    this.latitude,
    this.longitude,
    this.totalhouseDatascount,
    this.todayhouseDatascount,
    this.totalsampleDatascount,
    this.todaysampleDatascount,
  });

  String? referenceNo;
  String? date;
  String? zoneName;
  String? wardName;
  String? streetName;
  String? areaName;
  String? latitude;
  String? longitude;
  int? totalhouseDatascount;
  int? todayhouseDatascount;
  int? totalsampleDatascount;
  int? todaysampleDatascount;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
    referenceNo: json["reference_no"],
    date: json["date"],
    zoneName: json["zone_name"],
    wardName: json["ward_name"],
    streetName: json["street_name"],
    areaName: json["area_name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    totalhouseDatascount: json["totalhouseDatascount"],
    todayhouseDatascount: json["todayhouseDatascount"],
    totalsampleDatascount: json["totalsampleDatascount"],
    todaysampleDatascount: json["todaysampleDatascount"],
  );

  Map<String, dynamic> toJson() => {
    "reference_no": referenceNo,
    "date": date,
    "zone_name": zoneName,
    "ward_name": wardName,
    "street_name": streetName,
    "area_name": areaName,
    "latitude": latitude,
    "longitude": longitude,
    "totalhouseDatascount": totalhouseDatascount,
    "todayhouseDatascount": todayhouseDatascount,
    "totalsampleDatascount": totalsampleDatascount,
    "todaysampleDatascount": todaysampleDatascount,
  };
}
