class PaymentHistoryData {
  PaymentHistoryData({
    this.amount,
    this.paymentDate,
    this.paymentype,
  });

  int? amount;
  DateTime? paymentDate;
  String? paymentype;

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) => PaymentHistoryData(
    amount: json["amount"],
    paymentDate: DateTime.parse(json["payment_date"]),
    paymentype: json["paymentype"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "payment_date": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "paymentype": paymentype,
  };
}