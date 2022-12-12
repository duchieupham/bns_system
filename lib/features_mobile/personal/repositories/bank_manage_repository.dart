import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/firestore/bank_account_db.dart';
import 'package:vierqr/services/firestore/bank_notification_db.dart';

class BankManageRepository {
  const BankManageRepository();

  Future<List<String>> getBankIdsByUserId(String userId) async {
    List<String> result = [];
    try {
      result = await BankNotificationDB.instance.getBankIdsByUserId(userId);
    } catch (e) {
      print('Error at getBankIdsByUserId - BankManageRepository: $e');
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListOtherBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      List<String> bankIds =
          await BankNotificationDB.instance.getListBankIdByUserId(userId);
      if (bankIds.isNotEmpty) {
        result =
            await BankAccountDB.instance.getListBankAccountByBankIds(bankIds);
      }
    } catch (e) {
      print('Error at getListOtherBankAccount - BankManageRepository: $e');
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      result = await BankAccountDB.instance.getListBankAccount(userId);
    } catch (e) {
      print('Error at getListBankAccount - BankManageRepository: $e');
    }
    return result;
  }

  Future<bool> addBankAccount(
      String userId, BankAccountDTO dto, String phoneNo) async {
    bool result = false;
    try {
      bool checkAddBank =
          await BankAccountDB.instance.addBankAccount(userId, dto);
      bool checkAddRelation = await BankNotificationDB.instance
          .addUserToBankCard(
              dto.id, userId, Stringify.ROLE_CARD_MEMBER_ADMIN, phoneNo);
      if (checkAddBank && checkAddRelation) {
        result = true;
      }
    } catch (e) {
      print('Error at addBankAccount - BankManageRepository: $e');
    }
    return result;
  }

  Future<bool> removeBankAccount(
      String userId, String bankAccount, String bankId) async {
    bool result = false;
    try {
      bool checkRemoveBank =
          await BankAccountDB.instance.removeBankAccount(userId, bankAccount);
      bool checkRemoveRelation =
          await BankNotificationDB.instance.removeAllUsers(bankId);
      if (checkRemoveBank && checkRemoveRelation) {
        result = true;
      }
    } catch (e) {
      print('Error at removeBankAccount - BankManageRepository: $e');
    }
    return result;
  }
}
