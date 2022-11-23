import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/firestore/bank_account_db.dart';

class BankManageRepository {
  const BankManageRepository();

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      result = await BankAccountDB.instance.getListBankAccount(userId);
    } catch (e) {
      print('Error at getListBankAccount - BankManageRepository: $e');
    }
    return result;
  }

  Future<bool> addBankAccount(String userId, BankAccountDTO dto) async {
    bool result = false;
    try {
      result = await BankAccountDB.instance.addBankAccount(userId, dto);
    } catch (e) {
      print('Error at addBankAccount - BankManageRepository: $e');
    }
    return result;
  }

  Future<bool> removeBankAccount(String userId, String bankAccount) async {
    bool result = false;
    try {
      result =
          await BankAccountDB.instance.removeBankAccount(userId, bankAccount);
    } catch (e) {
      print('Error at removeBankAccount - BankManageRepository: $e');
    }
    return result;
  }
}
