import 'package:vierqr/models/account_register_dto.dart';
import 'package:vierqr/models/checking_dto.dart';
import 'package:vierqr/services/firestore/user_account_db.dart';
import 'package:vierqr/services/firestore/user_information_db.dart';

class RegisterRepository {
  const RegisterRepository();

  Future<CheckingDTO> register(AccountRegisterDTO dto) async {
    CheckingDTO result = const CheckingDTO(check: false, message: '');
    try {
      result = await UserAccountDB.instance
          .insertUserAccount(dto.toUserAccountJson());
      if (result.check) {
        await UserInformationDB.instance
            .insertUserInformation(dto.toUserInformationJson());
      }
    } catch (e) {
      print('Error at register - Register Repository: $e');
    }
    return result;
  }
}
