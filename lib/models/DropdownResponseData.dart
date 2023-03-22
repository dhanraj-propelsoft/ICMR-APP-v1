import 'package:wapindex/models/NameData.dart';
import 'package:wapindex/models/PaymentHistoryData.dart';

class DropdownResponseData {
  DropdownResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<NameData>? data;
  String? message;

  factory DropdownResponseData.fromJson(Map<String, dynamic> json) => DropdownResponseData(
    success: json["success"],
    data: json["data"]!=null?List<NameData>.from(json["data"].map((x) => NameData.fromJson(x))):[],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<NameData>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}


