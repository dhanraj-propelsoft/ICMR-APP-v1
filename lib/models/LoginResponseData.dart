class LoginResponseData {
  LoginResponseData({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
    success: json["success"],
    data: json["data"]!=null?Data.fromJson(json["data"]):null,
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.token,
    this.name,
    this.profile,
  });

  String? token;
  String? name;
  Profile? profile;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    name: json["name"],
    profile:json["profile"]!=null? Profile.fromJson(json["profile"]):null,
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "profile": profile!.toJson(),
  };
}

class Profile {
  Profile({
    this.personId,
    this.id,
    this.name,
    this.mobileNo,
    this.email,
    this.emailVerifiedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? personId;
  int? id;
  String? name;
  String? mobileNo;
  String? email;
  String? emailVerifiedAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    personId: json["person_id"],
    id: json["id"],
    name: json["name"],
    mobileNo: json["mobile_no"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "person_id": personId,
    "id": id,
    "name": name,
    "mobile_no": mobileNo,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
