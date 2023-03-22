
class PendingSamplesData {
  PendingSamplesData({
    this.type,
    this.id,
    this.streetDetailId,
    this.districtDetailId,
    this.referenceNo,
    this.date,
    this.zoneName,
    this.wardName,
    this.streetName,
    this.areaName,
    this.streetLat,
    this.streetLong,
    this.districtName,
    this.distLat,
    this.distLong,
  });

  String? type;
  int? id;
  String? streetDetailId;
  String? districtDetailId;
  String? referenceNo;
  DateTime? date;
  String? zoneName;
  String? wardName;
  String? streetName;
  String? areaName;
  String? streetLat;
  String? streetLong;
  String? districtName;
  String? distLat;
  String? distLong;

  factory PendingSamplesData.fromJson(Map<String, dynamic> json) => PendingSamplesData(
    type: json["type"],
    id: json["id"],
    streetDetailId: json["street_detail_id"],
    districtDetailId: json["district_detail_id"],
    referenceNo: json["reference_no"],
    date:json["date"]!=null? DateTime.parse(json["date"]):null,
    zoneName: json["zone_name"],
    wardName: json["ward_name"],
    streetName: json["street_name"],
    areaName: json["area_name"],
    streetLat: json["streetLat"],
    streetLong: json["streetLong"],
    districtName: json["district_name"],
    distLat: json["distLat"],
    distLong: json["distLong"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "street_detail_id": streetDetailId,
    "district_detail_id": districtDetailId,
    "reference_no": referenceNo,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "zone_name": zoneName,
    "ward_name": wardName,
    "street_name": streetName,
    "area_name": areaName,
    "streetLat": streetLat,
    "streetLong": streetLong,
    "district_name": districtName,
    "distLat": distLat,
    "distLong": distLong,
  };
}