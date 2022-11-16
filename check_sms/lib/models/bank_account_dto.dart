class BankAccountDTO {
  final String address;
  final String bankAccount;
  final String bankName;
  final String bankAccountName;

  const BankAccountDTO({
    required this.address,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankName,
  });

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      address: json['address'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankName: json['bankName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['address'] = address;
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankName'] = bankName;
    return data;
  }
}
