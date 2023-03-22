
class SchemeData {
  SchemeData({
    this.id,
    this.name,
    this.amount,
    this.period,
    this.subscriber,
    this.baseValue,
    this.status,
    this.startDate,
    this.bidDate,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.ticketNo,
    this.schemeId,
    this.userId,
  });

  int? id;
  String? name;
  String? amount;
  int? period;
  int? subscriber;
  String? baseValue;
  int? status;
  DateTime? startDate;
  String? bidDate;
  String? dueDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? ticketNo;
  int? schemeId;
  int? userId;

  factory SchemeData.fromJson(Map<String, dynamic> json) => SchemeData(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    period: json["period"],
    subscriber: json["subscriber"],
    baseValue: json["baseValue"],
    status: json["status"],
    startDate: DateTime.parse(json["startDate"]),
    bidDate:json["bidDate"]!=null? json["bidDate"].toString():"",
    dueDate: json["dueDate"]!=null?json["dueDate"].toString():"",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    ticketNo: json["ticketNo"],
    schemeId: json["scheme_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "period": period,
    "subscriber": subscriber,
    "baseValue": baseValue,
    "status": status,
    "startDate": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "bidDate": bidDate,
    "dueDate": dueDate,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "ticketNo": ticketNo,
    "scheme_id": schemeId,
    "user_id": userId,
  };
}


//class SchemeData {
//  SchemeData({
//    this.serialOrderNo,
//    this.dueAmount,
//    this.dueDate,
//    this.auctionDate,
//    this.paymentStatus,
//  });
//
//  String? serialOrderNo;
//  String? dueAmount;
//  int? dueDate;
//  int? auctionDate;
//  String? paymentStatus;
//
//  factory SchemeData.fromJson(Map<String, dynamic> json) => SchemeData(
//    serialOrderNo: json["serial_order_no"],
//    dueAmount: json["due_amount"],
//    dueDate: json["due_date"],
//    auctionDate: json["auction_date"],
//    paymentStatus: json["payment_status"],
//  );
//
//  Map<String, dynamic> toJson() => {
//    "serial_order_no": serialOrderNo,
//    "due_amount": dueAmount,
//    "due_date": dueDate,
//    "auction_date": auctionDate,
//    "payment_status": paymentStatus,
//  };
//}
