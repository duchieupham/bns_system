class BankAccountDTO {
  final String id;
  final String bankAccount;
  final String bankName;
  final String bankCode;
  final String bankAccountName;

  const BankAccountDTO({
    required this.id,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
  });

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      id: json['id'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankName'] = bankName;
    data['bankCode'] = bankCode;
    return data;
  }
}
