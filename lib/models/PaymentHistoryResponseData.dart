import 'package:wapindex/models/PaymentHistoryData.dart';

class PaymentHistoryResponseData {
  PaymentHistoryResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<PaymentHistoryData>? data;
  String? message;

  factory PaymentHistoryResponseData.fromJson(Map<String, dynamic> json) => PaymentHistoryResponseData(
    success: json["success"],
    data: json["data"]!=null?List<PaymentHistoryData>.from(json["data"].map((x) => PaymentHistoryData.fromJson(x))):[],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<PaymentHistoryData>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}


