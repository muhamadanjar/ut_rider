class Bank {
  final String bankCode;
  final String bankName;

  Bank({this.bankCode, this.bankName});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return new Bank(
        bankCode: json['bank_code'], bankName: json['bank_name']);
  }
}