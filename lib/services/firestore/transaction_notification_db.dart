import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/transaction_notification_dto.dart';

class TransactionNotificationDB {
  const TransactionNotificationDB._privateConsrtructor();

  static const TransactionNotificationDB _instance =
      TransactionNotificationDB._privateConsrtructor();
  static TransactionNotificationDB get instance => _instance;
  static final transactionNotificationDB =
      FirebaseFirestore.instance.collection('transaction-notification');

  //listen new data
  Stream<QuerySnapshot> listenTransactionNotification(String userId) {
    return FirebaseFirestore.instance
        .collection('transaction-notification')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots();
  }

  //insert
  Future<bool> insertTransactionNotification(
      TransactionNotificationDTO dto) async {
    bool result = false;
    try {
      await transactionNotificationDB
          .where('transactionId', isEqualTo: dto.transactionId)
          .where('userId', isEqualTo: dto.userId)
          // .where('timeCreated', isEqualTo: dto.timeCreated)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          await transactionNotificationDB
              .add(dto.toJson())
              .then((value) => result = true);
        } else {
          result = true;
        }
      });
    } catch (e) {
      print(
          'Error at insertTransactionNotification - TransactionNotificationDB: $e');
    }
    return result;
  }

  //update status
  Future<bool> updateTransactionNotification(String id) async {
    bool result = false;
    try {
      await transactionNotificationDB
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.update({'isRead': true});
        }
        result = true;
      });
    } catch (e) {
      print(
          'Error at updateTransactionNotification - TransactionNotificationDB: $e');
    }
    return result;
  }
}
