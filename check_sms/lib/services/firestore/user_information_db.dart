import 'package:check_sms/models/user_information_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformationDB {
  const UserInformationDB._privateConsrtructor();

  static const UserInformationDB _instance =
      UserInformationDB._privateConsrtructor();
  static UserInformationDB get instance => _instance;
  static final userInformationDb =
      FirebaseFirestore.instance.collection('user-information');

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
      await userInformationDb
          .where('id', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String userId = querySnapshot.docs.first['id'];
          String firstName = querySnapshot.docs.first['firstName'];
          String middleName = querySnapshot.docs.first['middleName'];
          String lastName = querySnapshot.docs.first['lastName'];
          String birthDate = querySnapshot.docs.first['birthDate'];
          String phoneNo = querySnapshot.docs.first['phoneNo'];
          bool gender = querySnapshot.docs.first['gender'];
          String address = querySnapshot.docs.first['address'];
          result = UserInformationDTO(
            userId: userId,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            birthDate: birthDate,
            gender: gender.toString(),
            phoneNo: phoneNo,
            address: address,
          );
        }
      });
    } catch (e) {
      print('Error at getUserInformation - UserInformationDB: $e');
    }
    return result;
  }
}
