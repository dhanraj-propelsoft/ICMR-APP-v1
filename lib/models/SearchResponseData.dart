class SearchResponseData {
  SearchResponseData({
    this.success,
    this.data,
  });

  bool? success;
  Data? data;

  factory SearchResponseData.fromJson(Map<String, dynamic> json) => SearchResponseData(
    success: json["success"],
    data: json["data"]!=null&&json["data"]!.toString().length>0?Data.fromJson(json["data"]):null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.virusStatus,
    this.type,
    this.districtname,
    this.zonename,
    this.wardname,
    this.streetname,
    this.date,
    this.referenceNo,
    this.latitude,
    this.longitude,
  });

  int? id;
  String? virusStatus;
  String? type;
  String? districtname;
  String? zonename;
  String? wardname;
  String? streetname;
  DateTime? date;
  String? referenceNo;
  String? latitude;
  String? longitude;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    virusStatus: json["virus_status"],
    type: json["type"],
    districtname: json["districtname"],
    zonename: json["zonename"],
    wardname: json["wardname"],
    streetname: json["streetname"],
    date: DateTime.parse(json["date"]),
    referenceNo: json["referenceNo"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "virus_status": virusStatus,
    "type": type,
    "districtname": districtname,
    "zonename": zonename,
    "wardname": wardname,
    "streetname": streetname,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "referenceNo": referenceNo,
    "latitude": latitude,
    "longitude": longitude,
  };
}
