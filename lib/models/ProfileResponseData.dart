import 'ProfileData.dart';

class ProfileResponseData {
  ProfileResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  ProfileData? data;
  String? message;

  factory ProfileResponseData.fromJson(Map<String, dynamic> json) => ProfileResponseData(
    success: json["success"],
    data: ProfileData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

