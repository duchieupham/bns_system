import 'package:vierqr/models/bank_account_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountDB {
  const BankAccountDB._privateConsrtructor();

  static const BankAccountDB _instance = BankAccountDB._privateConsrtructor();
  static BankAccountDB get instance => _instance;
  static final bankAccountDb =
      FirebaseFirestore.instance.collection('user-bank');

  Future<List<BankAccountDTO>> getListBankAccountByBankIds(
      List<String> bankIds) async {
    List<BankAccountDTO> result = [];
    try {
      for (String bankId in bankIds) {
        BankAccountDTO dto = const BankAccountDTO(
            id: '',
            bankAccount: '',
            bankAccountName: '',
            bankName: '',
            bankCode: '');
        await bankAccountDb
            .where('id', isEqualTo: bankId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            String id = querySnapshot.docs.first['id'] ?? '';
            String bankAccount = querySnapshot.docs.first['bankAccount'] ?? '';
            String bankAccountName =
                querySnapshot.docs.first['bankAccountName'] ?? '';
            String bankCode = querySnapshot.docs.first['bankCode'] ?? '';
            String bankName = querySnapshot.docs.first['bankName'] ?? '';
            dto = BankAccountDTO(
              id: id,
              bankAccount: bankAccount,
              bankAccountName: bankAccountName,
              bankName: bankName,
              bankCode: bankCode,
            );
          }
        });
        if (dto.id != '') {
          result.add(dto);
        }
      }
    } catch (e) {
      print('Error at getListBankAccountByBankIds - BankAccountDB: $e');
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      await bankAccountDb
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            String id = querySnapshot.docs[i]['id'];
            String bankAccount = querySnapshot.docs[i]['bankAccount'];
            String bankAccountName = querySnapshot.docs[i]['bankAccountName'];
            String bankCode = querySnapshot.docs[i]['bankCode'];
            String bankName = querySnapshot.docs[i]['bankName'];
            BankAccountDTO dto = BankAccountDTO(
              id: id,
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
          .where('userId', isEqualTo: userId)
          .where('bankAccount', isEqualTo: dto.bankAccount)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          Map<String, dynamic> data = {
            'id': dto.id,
            'userId': userId,
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
          .where('userId', isEqualTo: userId)
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
