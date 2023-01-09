import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/models/user_information_dto.dart';
import 'package:vierqr/services/firestore/user_account_db.dart';
import 'package:vierqr/services/firestore/user_information_db.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserEditRepository {
  const UserEditRepository();

  Future<bool> updateUserInformation(UserInformationDTO dto) async {
    bool result = false;
    try {
      result = await UserInformationDB.instance.updateUserInformation(dto);
      if (result) {
        await UserInformationHelper.instance.setUserInformation(dto);
      }
    } catch (e) {
      print('Error at updateUserInformation - UserEditRepository: $e');
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(String userId, String oldPassword,
      String newPassword, String phoneNo) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      result = await UserAccountDB.instance.updatePassword(
        userId,
        EncryptUtils.instance.encrypted(phoneNo, oldPassword),
        EncryptUtils.instance.encrypted(phoneNo, newPassword),
      );
    } catch (e) {
      print('Error at updatePassword - UserEditRepository: $e');
    }
    return result;
  }
}
