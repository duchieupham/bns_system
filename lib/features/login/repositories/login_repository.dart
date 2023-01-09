import 'package:rxdart/subjects.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/code_login_dto.dart';
import 'package:vierqr/models/user_information_dto.dart';
import 'package:vierqr/services/firestore/code_login_db.dart';
import 'package:vierqr/services/firestore/user_account_db.dart';
import 'package:vierqr/services/firestore/user_information_db.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class LoginRepository {
  static final codeLoginController = BehaviorSubject<CodeLoginDTO>();

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
          .getUserInformation(userId, null)
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

  //listen login code
  void listenLoginCode(String code) {
    try {
      CodeLoginDB.instance.listenLoginCode(code).listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> data =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          CodeLoginDTO codeLoginDTO = CodeLoginDTO.fromJson(data);
          if (codeLoginDTO.userId.isNotEmpty) {
            codeLoginController.sink.add(codeLoginDTO);
          }
        }
      });
    } catch (e) {
      print('Error at listenLoginCode - LoginRepository: $e');
    }
  }

  //insert login code
  Future<bool> insertCodeLogin(CodeLoginDTO dto) async {
    bool result = false;
    try {
      result = await CodeLoginDB.instance.insertCodeLogin(dto);
    } catch (e) {
      print('Error at insertCodeLogin - LoginRepository: $e');
    }
    return result;
  }

  //update login code
  Future<void> updateCodeLogin(CodeLoginDTO dto) async {
    try {
      await CodeLoginDB.instance.updateCodeLogin(dto);
    } catch (e) {
      print('Error at updateCodeLogin - LoginRepository: $e');
    }
  }

  //delete login code
  Future<bool> deleteCodeLogin(String code) async {
    bool result = false;
    try {
      result = await CodeLoginDB.instance.deleteCodeLogin(code);
    } catch (e) {
      print('Error at deleteCodeLogin - LoginRepository: $e');
    }
    return result;
  }
}
