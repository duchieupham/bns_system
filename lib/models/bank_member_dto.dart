import 'package:cloud_firestore/cloud_firestore.dart';

class BankMemberDTO {
  final String id;
  final String bankId;
  final String userId;
  final String role;
  //for case user is not contains into system
  final String phoneNo;
  final dynamic time;

  const BankMemberDTO({
    required this.id,
    required this.bankId,
    required this.userId,
    required this.role,
    required this.phoneNo,
    required this.time,
  });

  factory BankMemberDTO.fromJson(Map<String, dynamic> json) {
    return BankMemberDTO(
      id: json['id'] ?? '',
      bankId: json['bankId'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      time: json['time'] ?? FieldValue.serverTimestamp(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['role'] = role;
    data['phoneNo'] = phoneNo;
    data['time'] = time;
    return data;
  }
}
