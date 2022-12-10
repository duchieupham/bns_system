import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/models/bank_notification_dto.dart';

class BankNotificationDB {
  const BankNotificationDB._privateConsrtructor();

  static const BankNotificationDB _instance =
      BankNotificationDB._privateConsrtructor();
  static BankNotificationDB get instance => _instance;
  static final bankNotificationDb =
      FirebaseFirestore.instance.collection('bank-notification');

  Future<List<String>> getListBankIdByUserId(String userId) async {
    List<String> result = [];
    try {
      await bankNotificationDb
          .where('userId', isEqualTo: userId)
          .where('role', isNotEqualTo: Stringify.ROLE_CARD_MEMBER_ADMIN)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          for (var element in querySnapshot.docs) {
            String bankId = element['bankId'] ?? '';
            result.add(bankId);
          }
        }
      });
    } catch (e) {
      print('Error at getListBankIdByUserId - BankNotificationDB: $e');
    }

    return result;
  }

  Future<List<BankNotificationDTO>> getListBankNotification(
      String bankId) async {
    List<BankNotificationDTO> result = [];
    try {
      await bankNotificationDb
          .where('bankId', isEqualTo: bankId)
          .orderBy('time')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          for (var element in querySnapshot.docs) {
            BankNotificationDTO dto = BankNotificationDTO(
              id: element['id'] ?? '',
              bankId: element['bankId'] ?? '',
              userId: element['userId'] ?? '',
              role: element['role'] ?? '',
              phoneNo: element['phoneNo'] ?? '',
              time: element['time'] ?? FieldValue.serverTimestamp(),
            );
            result.add(dto);
          }
        }
      });
    } catch (e) {
      print('Error at getListBankNotification - BankNotificationDB: $e');
    }
    return result;
  }

  Future<bool> addUserToBankCard(
      String bankId, String userId, String role, String phoneNo) async {
    bool result = false;
    try {
      if (userId != '') {
        await bankNotificationDb
            .where('bankId', isEqualTo: bankId)
            .where('userId', isEqualTo: userId)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isEmpty) {
            const Uuid uuid = Uuid();
            BankNotificationDTO dto = BankNotificationDTO(
              id: uuid.v1(),
              bankId: bankId,
              userId: userId,
              role: role,
              phoneNo: phoneNo,
              time: FieldValue.serverTimestamp(),
            );
            await bankNotificationDb
                .add(dto.toJson())
                .then((value) => result = true);
          }
        });
      } else {
        const Uuid uuid = Uuid();
        BankNotificationDTO dto = BankNotificationDTO(
          id: uuid.v1(),
          bankId: bankId,
          userId: userId,
          role: role,
          phoneNo: phoneNo,
          time: FieldValue.serverTimestamp(),
        );
        await bankNotificationDb
            .add(dto.toJson())
            .then((value) => result = true);
      }
    } catch (e) {
      print('Error at addParentUser - BankNotificationDB: $e');
    }
    return result;
  }

  Future<bool> removeUserFromBank(String bankId, String userId) async {
    bool result = false;
    try {
      await bankNotificationDb
          .where('bankId', isEqualTo: bankId)
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference
              .delete()
              .then((value) => result = true);
        }
      });
    } catch (e) {
      print('Error at removeUserFromBank - BankNotificationDB: $e');
    }
    return result;
  }

  Future<bool> removeAllUsers(String bankId) async {
    bool result = false;
    try {
      await bankNotificationDb
          .where('bankId', isEqualTo: bankId)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            await querySnapshot.docs[i].reference
                .delete()
                .then((value) => result = true);
          }
        }
      });
    } catch (e) {
      print('Error at removeAllUsers - BankNotificationDB: $e');
    }
    return result;
  }

  // Future<bool> addUsers(String bankId, List<String> userIds) async {
  //   bool result = false;
  //   try {
  //     await bankNotificationDb
  //         .where('bankId', isEqualTo: bankId)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) async {
  //       //
  //       if (querySnapshot.docs.isNotEmpty) {
  //         for (String userId in userIds) {
  //           for (var element in querySnapshot.docs) {
  //             if (userId != element['userId']) {
  //               const Uuid uuid = Uuid();
  //               BankNotificationDTO dto = BankNotificationDTO(
  //                 id: uuid.v1(),
  //                 bankId: bankId,
  //                 userId: userId,
  //                 role: 'child',
  //                 time: FieldValue.serverTimestamp(),
  //               );
  //               await bankNotificationDb
  //                   .add(dto.toJson())
  //                   .then((value) => result = true);
  //             }
  //           }
  //         }
  //       } else {
  //         for (String userId in userIds) {
  //           const Uuid uuid = Uuid();
  //           BankNotificationDTO dto = BankNotificationDTO(
  //             id: uuid.v1(),
  //             bankId: bankId,
  //             userId: userId,
  //             role: 'child',
  //             time: FieldValue.serverTimestamp(),
  //           );
  //           await bankNotificationDb
  //               .add(dto.toJson())
  //               .then((value) => result = true);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print('Error at addUsers - BankNotificationDB: $e');
  //   }
  //   return result;
  // }

}
