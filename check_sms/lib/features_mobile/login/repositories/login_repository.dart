import 'package:check_sms/models/account_login_dto.dart';
import 'package:check_sms/models/user_information_dto.dart';
import 'package:check_sms/services/firestore/user_account_db.dart';
import 'package:check_sms/services/firestore/user_information_db.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';

class LoginRepository {
  const LoginRepository();

  Future<Map<String, dynamic>> login(AccountLoginDTO dto) async {
    Map<String, dynamic> result = {'isLogin': false, 'userId': ''};
    try {
      String userId =
          await UserAccountDB.instance.login(dto.phoneNo, dto.password);
      if (userId.isNotEmpty) {
        await UserInformationHelper.instance.setUserId(userId);
        result['isLogin'] = true;
        result['userId'] = userId;
      }
    } catch (e) {
      print('Error at login: $e');
    }
    return result;
  }

  Future<bool> getUserInformation(String userId) async {
    bool result = false;
    try {
      await UserInformationDB.instance
          .getUserInformation(userId)
          .then((value) async {
        UserInformationDTO dto = value;
        if (value.userId != '') {
          await UserInformationHelper.instance.setUserInformation(dto);
          result = true;
        }
      });

      result = true;
    } catch (e) {
      print('Error at getUserInformation - login repository: $e');
    }
    return result;
  }
}
