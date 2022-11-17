class BankAccountDTO {
  final String bankAccount;
  final String bankName;
  final String bankCode;
  final String bankAccountName;

  const BankAccountDTO({
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
  });

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankName'] = bankName;
    data['bankCode'] = bankCode;
    return data;
  }
}
