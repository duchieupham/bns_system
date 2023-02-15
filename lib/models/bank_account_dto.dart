class BankAccountDTO {
  final String id;
  final String bankAccount;
  final String bankName;
  final String bankCode;
  final String bankAccountName;
  final String userId;

  const BankAccountDTO({
    required this.id,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
    required this.userId,
  });

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      id: json['id'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankName'] = bankName;
    data['bankCode'] = bankCode;
    data['userId'] = userId;
    return data;
  }
}
