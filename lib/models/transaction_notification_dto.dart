class TransactionNotificationDTO {
  final String id;
  final String transactionId;
  final String userId;
  final dynamic timeCreated;
  final bool isRead;

  const TransactionNotificationDTO({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.timeCreated,
    required this.isRead,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['transactionId'] = transactionId;
    data['userId'] = userId;
    data['timeCreated'] = timeCreated;
    data['isRead'] = isRead;
    return data;
  }
}
