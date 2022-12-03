import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountDB {
  const UserAccountDB._privateConsrtructor();

  static const UserAccountDB _instance = UserAccountDB._privateConsrtructor();
  static UserAccountDB get instance => _instance;
  static final userAccountDb =
      FirebaseFirestore.instance.collection('user-account');

  Future<bool> insertUserAccount(Map<String, dynamic> data) async {
    bool result = false;
    try {
      await userAccountDb.add(data).then((value) => result = true);
    } catch (e) {
      print('Error at insertUserAccount - UserAccountDB: $e');
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(
      String userId, String oldPassword, String newPassword) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      await userAccountDb
          .where('id', isEqualTo: userId)
          .where('password', isEqualTo: oldPassword)
          .get()
          .then(
        (QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference
                .update({'password': newPassword}).then((_) {
              result = {'check': true, 'msg': ''};
            });
          } else {
            result = {
              'check': false,
              'msg': 'Mã PIN cũ không chính xác, vui lòng thử lại.'
            };
          }
        },
      );
    } catch (e) {
      result = {'check': false, 'msg': 'Vui lòng kiểm tra lại kết nối mạng.'};
      print('Error at updatePassword - UserAccountDB: $e');
    }
    return result;
  }

  Future<String> login(String phone, String password) async {
    String result = '';
    try {
      await userAccountDb
          .where('phoneNo', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          result = querySnapshot.docs.first['id'] ?? '';
        }
      });
    } catch (e) {
      print('Error at login - UserAccountDB: $e');
    }
    return result;
  }
}
