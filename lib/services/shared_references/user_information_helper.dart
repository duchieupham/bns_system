import 'dart:convert';

import 'package:vierqr/main.dart';
import 'package:vierqr/models/user_information_dto.dart';

class UserInformationHelper {
  const UserInformationHelper._privateConsrtructor();

  static const UserInformationHelper _instance =
      UserInformationHelper._privateConsrtructor();
  static UserInformationHelper get instance => _instance;

  Future<void> initialUserInformationHelper() async {
    const UserInformationDTO dto = UserInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 'false',
      phoneNo: '',
      address: '',
    );
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('USER_INFORMATION', dto.toSPJson().toString());
  }

  Future<void> setUserId(String userId) async {
    await sharedPrefs.setString('USER_ID', userId);
  }

  Future<void> setUserInformation(UserInformationDTO dto) async {
    await sharedPrefs.setString('USER_INFORMATION', dto.toSPJson().toString());
  }

  UserInformationDTO getUserInformation() {
    return UserInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('USER_INFORMATION')!));
  }

  String getUserId() {
    return sharedPrefs.getString('USER_ID')!;
  }

  String getUserFullname() {
    return ('${getUserInformation().lastName} ${getUserInformation().middleName} ${getUserInformation().firstName}')
        .trim();
  }
}
