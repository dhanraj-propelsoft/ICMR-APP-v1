
class CommonResponseData {
  CommonResponseData({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory CommonResponseData.fromJson(Map<String, dynamic> json) => CommonResponseData(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
