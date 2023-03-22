class SchemeDetailsData {
  SchemeDetailsData({
    this.serialOrderNo,
    this.schemeAmount,
    this.totalNoOfSubsriber,
    this.monthlySubscdiption,
    this.period,
    this.startedOn,
    this.closureOn,
    this.noOfDuesPaid,
    this.noOfDuesRemaining,
    this.lAuctionDate,
    this.lBitAmount,
  });

  String? serialOrderNo;
  String? schemeAmount;
  int? totalNoOfSubsriber;
  String? monthlySubscdiption;
  int? period;
  DateTime? startedOn;
  DateTime? closureOn;
  int? noOfDuesPaid;
  int? noOfDuesRemaining;
  String? lAuctionDate;
  String? lBitAmount;

  factory SchemeDetailsData.fromJson(Map<String, dynamic> json) => SchemeDetailsData(
    serialOrderNo: json["serial_order_no"],
    schemeAmount: json["scheme_amount"],
    totalNoOfSubsriber: json["total_no_of_subsriber"],
    monthlySubscdiption: json["monthly_subscdiption"],
    period: json["period"],
    startedOn: DateTime.parse(json["started_on"]),
    closureOn: DateTime.parse(json["closure_on"]),
    noOfDuesPaid: json["no_of_dues_paid"],
    noOfDuesRemaining: json["no_of_dues_remaining"],
    lAuctionDate: json["l_auction_date"],
    lBitAmount: json["l_bit_amount"],
  );

  Map<String, dynamic> toJson() => {
    "serial_order_no": serialOrderNo,
    "scheme_amount": schemeAmount,
    "total_no_of_subsriber": totalNoOfSubsriber,
    "monthly_subscdiption": monthlySubscdiption,
    "period": period,
    "started_on": "${startedOn!.year.toString().padLeft(4, '0')}-${startedOn!.month.toString().padLeft(2, '0')}-${startedOn!.day.toString().padLeft(2, '0')}",
    "closure_on": closureOn!.toIso8601String(),
    "no_of_dues_paid": noOfDuesPaid,
    "no_of_dues_remaining": noOfDuesRemaining,
    "l_auction_date": lAuctionDate,
    "l_bit_amount": lBitAmount,
  };
}
