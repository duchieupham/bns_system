class TransactionNotificationDTO {
  final String id;
  final String transactionId;
  final String userId;
  // final dynamic timeCreated;
  final bool isRead;
  final String content;
  final String address;
  final bool isFormatted;

  const TransactionNotificationDTO({
    required this.id,
    required this.transactionId,
    required this.userId,
    //  required this.timeCreated,
    required this.isRead,
    required this.content,
    required this.address,
    required this.isFormatted,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['transactionId'] = transactionId;
    data['userId'] = userId;
    // data['timeCreated'] = timeCreated;
    data['isRead'] = isRead;
    data['content'] = content;
    data['address'] = address;
    data['isFormatted'] = isFormatted;
    return data;
  }
}
