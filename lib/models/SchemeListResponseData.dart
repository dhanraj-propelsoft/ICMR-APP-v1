import 'SchemeData.dart';

class SchemeListResponseData {
  SchemeListResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<SchemeData>? data;
  String? message;

  factory SchemeListResponseData.fromJson(Map<String, dynamic> json) => SchemeListResponseData(
    success: json["success"],
    data:json["data"]!=null? List<SchemeData>.from(json["data"].map((x) => SchemeData.fromJson(x))):[],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<SchemeData>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

