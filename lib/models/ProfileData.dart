class ProfileData {
  ProfileData({
    this.id,
    this.firstName,
    this.firstName1,
    this.lastName,
    this.email,
    this.age,
    this.age1,
    this.dob,
    this.emailVerifiedAt,
    this.mobile1,
    this.mobile2,
    this.addressProfName,
    this.addressProfPath,
    this.photoName,
    this.photoPath,
    this.idProfName,
    this.idProfPath,
    this.role,
    this.passwordString,
    this.aadhar,
    this.relationship1,
    this.relationship2,
    this.pan,
    this.gst,
    this.guardian1,
    this.guardian2,
    this.bankname,
    this.accountnumber,
    this.ifsc,
    this.nomineename1,
    this.nomineerelationship1,
    this.nomineeage1,
    this.nomineeaddress1,
    this.nomineestreet1,
    this.nomineearea1,
    this.nomineecity1,
    this.nomineepin1,
    this.designation,
    this.nomineename2,
    this.nomineerelationship2,
    this.nomineeage2,
    this.nomineeaddress2,
    this.nomineestreet2,
    this.nomineearea2,
    this.nomineecity2,
    this.nomineepin2,
    this.address1,
    this.street1,
    this.area1,
    this.city1,
    this.pin1,
    this.address2,
    this.street2,
    this.area2,
    this.city2,
    this.pin2,
    this.address3,
    this.street3,
    this.area3,
    this.city3,
    this.pin3,
    this.address4,
    this.street4,
    this.area4,
    this.city4,
    this.pin4,
    this.address5,
    this.street5,
    this.area5,
    this.city5,
    this.pin5,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.startTime,
  });

  int? id;
  String? firstName;
  String? firstName1;
  String? lastName;
  String? email;
  int? age;
  int? age1;
  DateTime? dob;
  String? emailVerifiedAt;
  String? mobile1;
  String? mobile2;
  String? addressProfName;
  String? addressProfPath;
  String? photoName;
  String? photoPath;
  String? idProfName;
  String? idProfPath;
  String? role;
  String? passwordString;
  int? aadhar;
  String? relationship1;
  String? relationship2;
  String? pan;
  String? gst;
  String? guardian1;
  String? guardian2;
  String? bankname;
  int? accountnumber;
  String? ifsc;
  String? nomineename1;
  String? nomineerelationship1;
  int? nomineeage1;
  String? nomineeaddress1;
  String? nomineestreet1;
  String? nomineearea1;
  String? nomineecity1;
  int? nomineepin1;
  String? designation;
  String? nomineename2;
  String? nomineerelationship2;
  int? nomineeage2;
  String? nomineeaddress2;
  String? nomineestreet2;
  String? nomineearea2;
  String? nomineecity2;
  int? nomineepin2;
  String? address1;
  String? street1;
  String? area1;
  String? city1;
  int? pin1;
  String? address2;
  String? street2;
  String? area2;
  String? city2;
  int? pin2;
  String? address3;
  String? street3;
  String? area3;
  String? city3;
  String? pin3;
  String? address4;
  String? street4;
  String? area4;
  String? city4;
  int? pin4;
  String? address5;
  String? street5;
  String? area5;
  String? city5;
  int? pin5;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? startDate;
  dynamic startTime;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    firstName: json["firstName"],
    firstName1: json["firstName1"],
    lastName: json["lastName"],
    email: json["email"],
    age: json["age"],
    age1: json["age1"],
    dob: DateTime.parse(json["dob"]),
    emailVerifiedAt: json["email_verified_at"],
    mobile1: json["mobile1"],
    mobile2: json["mobile2"],
    addressProfName: json["addressProfName"],
    addressProfPath: json["addressProfPath"],
    photoName: json["photoName"],
    photoPath: json["photoPath"],
    idProfName: json["idProfName"],
    idProfPath: json["idProfPath"],
    role: json["role"],
    passwordString: json["passwordString"],
    aadhar: json["aadhar"],
    relationship1: json["relationship1"],
    relationship2: json["relationship2"],
    pan: json["pan"],
    gst: json["gst"],
    guardian1: json["guardian1"],
    guardian2: json["guardian2"],
    bankname: json["bankname"],
    accountnumber: json["accountnumber"],
    ifsc: json["ifsc"],
    nomineename1: json["nomineename1"],
    nomineerelationship1: json["nomineerelationship1"],
    nomineeage1: json["nomineeage1"],
    nomineeaddress1: json["nomineeaddress1"],
    nomineestreet1: json["nomineestreet1"],
    nomineearea1: json["nomineearea1"],
    nomineecity1: json["nomineecity1"],
    nomineepin1: json["nomineepin1"],
    designation: json["designation"],
    nomineename2: json["nomineename2"],
    nomineerelationship2: json["nomineerelationship2"],
    nomineeage2: json["nomineeage2"],
    nomineeaddress2: json["nomineeaddress2"],
    nomineestreet2: json["nomineestreet2"],
    nomineearea2: json["nomineearea2"],
    nomineecity2: json["nomineecity2"],
    nomineepin2: json["nomineepin2"],
    address1: json["address1"],
    street1: json["street1"],
    area1: json["area1"],
    city1: json["city1"],
    pin1: json["pin1"],
    address2: json["address2"],
    street2: json["street2"],
    area2: json["area2"],
    city2: json["city2"],
    pin2: json["pin2"],
    address3: json["address3"],
    street3: json["street3"],
    area3: json["area3"],
    city3: json["city3"],
    pin3: json["pin3"],
    address4: json["address4"],
    street4: json["street4"],
    area4: json["area4"],
    city4: json["city4"],
    pin4: json["pin4"],
    address5: json["address5"],
    street5: json["street5"],
    area5: json["area5"],
    city5: json["city5"],
    pin5: json["pin5"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    startDate: DateTime.parse(json["startDate"]),
    startTime: json["startTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "firstName1": firstName1,
    "lastName": lastName,
    "email": email,
    "age": age,
    "age1": age1,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "email_verified_at": emailVerifiedAt,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "addressProfName": addressProfName,
    "addressProfPath": addressProfPath,
    "photoName": photoName,
    "photoPath": photoPath,
    "idProfName": idProfName,
    "idProfPath": idProfPath,
    "role": role,
    "passwordString": passwordString,
    "aadhar": aadhar,
    "relationship1": relationship1,
    "relationship2": relationship2,
    "pan": pan,
    "gst": gst,
    "guardian1": guardian1,
    "guardian2": guardian2,
    "bankname": bankname,
    "accountnumber": accountnumber,
    "ifsc": ifsc,
    "nomineename1": nomineename1,
    "nomineerelationship1": nomineerelationship1,
    "nomineeage1": nomineeage1,
    "nomineeaddress1": nomineeaddress1,
    "nomineestreet1": nomineestreet1,
    "nomineearea1": nomineearea1,
    "nomineecity1": nomineecity1,
    "nomineepin1": nomineepin1,
    "designation": designation,
    "nomineename2": nomineename2,
    "nomineerelationship2": nomineerelationship2,
    "nomineeage2": nomineeage2,
    "nomineeaddress2": nomineeaddress2,
    "nomineestreet2": nomineestreet2,
    "nomineearea2": nomineearea2,
    "nomineecity2": nomineecity2,
    "nomineepin2": nomineepin2,
    "address1": address1,
    "street1": street1,
    "area1": area1,
    "city1": city1,
    "pin1": pin1,
    "address2": address2,
    "street2": street2,
    "area2": area2,
    "city2": city2,
    "pin2": pin2,
    "address3": address3,
    "street3": street3,
    "area3": area3,
    "city3": city3,
    "pin3": pin3,
    "address4": address4,
    "street4": street4,
    "area4": area4,
    "city4": city4,
    "pin4": pin4,
    "address5": address5,
    "street5": street5,
    "area5": area5,
    "city5": city5,
    "pin5": pin5,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "startDate": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "startTime": startTime,
  };
}
