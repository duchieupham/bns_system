import 'package:check_sms/models/account_login_dto.dart';
import 'package:check_sms/models/user_information_dto.dart';
import 'package:check_sms/services/firestore/login_db.dart';
import 'package:check_sms/services/firestore/user_information_db.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';

class LoginRepository {
  const LoginRepository();

  Future<bool> login(AccountLoginDTO dto) async {
    bool result = false;
    try {
      String userId = await LoginDB.instance.login(dto.phoneNo, dto.password);
      if (userId.isNotEmpty) {
        await UserInformationHelper.instance.setUserId(userId);
        result = true;
      }
    } catch (e) {
      print('Error at login: $e');
    }
    return result;
  }

  Future<UserInformationDTO> getUserInformation(String userId) async {
    UserInformationDTO result = const UserInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 'false',
      phoneNo: '',
      address: '',
    );
    try {
      result = await UserInformationDB.instance.getUserInformation(userId);
      await UserInformationHelper.instance.setUserInformation(result);
    } catch (e) {
      print('Error at getUserInformation - login repository: $e');
    }
    return result;
  }
}
