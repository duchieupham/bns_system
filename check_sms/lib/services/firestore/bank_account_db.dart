import 'package:check_sms/models/bank_account_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountDB {
  const BankAccountDB._privateConsrtructor();

  static const BankAccountDB _instance = BankAccountDB._privateConsrtructor();
  static BankAccountDB get instance => _instance;
  static final bankAccountDb =
      FirebaseFirestore.instance.collection('user-bank');

  Future<bool> insertUserBank(Map<String, dynamic> data) async {
    bool result = false;
    try {
      await bankAccountDb.add(data).then((value) => result = true);
    } catch (e) {
      print('Error at insertUserBank - BankAccountDB: $e');
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      await bankAccountDb
          .where('id', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            String bankAccount = querySnapshot.docs[i]['bankAccount'];
            String bankAccountName = querySnapshot.docs[i]['bankAccountName'];
            String bankCode = querySnapshot.docs[i]['bankCode'];
            String bankName = querySnapshot.docs[i]['bankName'];
            BankAccountDTO dto = BankAccountDTO(
              bankAccount: bankAccount,
              bankAccountName: bankAccountName,
              bankName: bankName,
              bankCode: bankCode,
            );
            result.add(dto);
          }
        }
      });
    } catch (e) {
      print('Error at getListBankAccount - BankAccountDB: $e');
    }
    return result;
  }

  Future<bool> addBankAccount(String userId, BankAccountDTO dto) async {
    bool result = false;
    try {
      //
      await bankAccountDb
          .where('id', isEqualTo: userId)
          .where('bankAccount', isEqualTo: dto.bankAccount)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          Map<String, dynamic> data = {
            'id': userId,
            'bankAccount': dto.bankAccount,
            'bankCode': dto.bankCode,
            'bankName': dto.bankName,
            'bankAccountName': dto.bankAccountName,
          };
          await bankAccountDb.add(data).then((value) => result = true);
        }
      });
    } catch (e) {
      print('Error at addBankAccount - BankAccountDB: $e');
    }
    return result;
  }

  Future<bool> removeBankAccount(String userId, String bankAccount) async {
    bool result = false;
    try {
      await bankAccountDb
          .where('id', isEqualTo: userId)
          .where('bankAccount', isEqualTo: bankAccount)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference
              .delete()
              .then((value) => result = true);
        }
      });
    } catch (e) {
      print('Error at removeBankAccount - BankAccountDB: $e');
    }
    return result;
  }
}
