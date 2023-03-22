import 'PendingSamplesData.dart';

class SamplesListResponseData {
  SamplesListResponseData({
    this.success,
    this.data,
  });

  bool? success;
  List<PendingSamplesData>? data;

  factory SamplesListResponseData.fromJson(Map<String, dynamic> json) => SamplesListResponseData(
    success: json["success"],
    data:json["data"]!=null? List<PendingSamplesData>.from(json["data"].map((x) => PendingSamplesData.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


