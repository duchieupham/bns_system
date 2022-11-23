import 'package:check_sms/models/account_register_dto.dart';
import 'package:check_sms/services/firestore/bank_account_db.dart';
import 'package:check_sms/services/firestore/user_account_db.dart';
import 'package:check_sms/services/firestore/user_information_db.dart';

class RegisterRepository {
  const RegisterRepository();

  Future<bool> register(AccountRegisterDTO dto) async {
    bool result = false;
    try {
      await UserAccountDB.instance.insertUserAccount(dto.toUserAccountJson());
      await UserInformationDB.instance
          .insertUserInformation(dto.toUserInformationJson());
      await BankAccountDB.instance.insertUserBank(dto.toUserBankJson());
      result = true;
    } catch (e) {
      print('Error at register - Register Repository: $e');
    }
    return result;
  }
}
