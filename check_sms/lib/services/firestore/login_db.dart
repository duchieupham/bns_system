import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDB {
  const LoginDB._privateConsrtructor();

  static const LoginDB _instance = LoginDB._privateConsrtructor();
  static LoginDB get instance => _instance;
  static final userAccountDb =
      FirebaseFirestore.instance.collection('user-account');

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
      print('Error at login - LoginDB: $e');
    }
    return result;
  }
}
