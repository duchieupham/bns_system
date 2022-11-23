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
