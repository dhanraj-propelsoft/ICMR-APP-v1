import 'package:wapindex/models/SchemeDetailsData.dart';

class SchemeDetailsResponseData {
  SchemeDetailsResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  SchemeDetailsData? data;
  String? message;

  factory SchemeDetailsResponseData.fromJson(Map<String, dynamic> json) => SchemeDetailsResponseData(
    success: json["success"],
    data: SchemeDetailsData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

